module Api
    class SchedulesController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:update]
      before_action :authenticate_user!
      before_action :find_project!

      # PATCH /api/projects/:project_id/schedule
      # Создаёт или обновляет расписание, а затем «переназначает» дедлайны
      def update
        schedule = @project.schedule || @project.build_schedule
        schedule.assign_attributes(schedule_params)

        if schedule.save
          reschedule_content_items!(schedule)
          render json: schedule, status: :ok
        else
          render json: schedule.errors, status: :unprocessable_entity
        end
      end

      private

      def schedule_params
        # Ожидаем { schedule: { start_date: "YYYY-MM-DD", weekdays: ["monday","wednesday",...] } }
        params.require(:schedule).permit(:start_date, weekdays: [])
      end

      def find_project!
        @project = Project
          .joins("LEFT JOIN project_specialists ON projects.id = project_specialists.project_id")
          .where(
            "projects.id = ? AND (projects.creator_id = ? OR project_specialists.user_id = ?)",
            params[:project_id].to_i, current_user.id, current_user.id
          ).first

        render(json: { error: 'Project not found or access denied' }, status: :not_found) unless @project
      end

      # Переназначаем дедлайны всем айтемам с deadline >= выбранного start_date,
      # группируя отдельно по платформе
      def reschedule_content_items!(schedule)
        selected = schedule.start_date
        wday_map = {
          'sunday'=>0,'monday'=>1,'tuesday'=>2,'wednesday'=>3,
          'thursday'=>4,'friday'=>5,'saturday'=>6
        }
        desired_wdays = schedule.weekdays.map { |wd| wday_map[wd.downcase] }.compact

        # Для каждой платформы отдельно
        schedule.project.content_plan_items
                .where('deadline >= ?', selected)
                .group_by(&:platform)
                .each do |platform, items|
          # сортируем по изначальному порядку (created_at)
          items = items.sort_by(&:created_at)
          # сколько дат нужно сгенерить
          count = items.size
          dates = []
          cursor = selected

          while dates.size < count
            dates << cursor if desired_wdays.include?(cursor.wday)
            cursor += 1.day
          end

          # обновляем в транзакции
          ContentPlanItem.transaction do
            items.zip(dates).each do |item, new_date|
              item.update!(deadline: new_date)
            end
          end
        end
      end

      # Ваша аутентификация
      def authenticate_user!
        render(json: { error: 'Authentication required' }, status: :unauthorized) unless current_user
      end

      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end
  end
