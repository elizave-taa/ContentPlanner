module Api
  class ContentPlanItemsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

    before_action :authenticate_user!
    before_action :find_accessible_project, only: [:index, :create]
    before_action :find_accessible_content_plan_item, only: [:show, :update, :destroy, :toggle_posted]

    # GET /api/projects/:project_id/content_plan_items
    def index
      render json: @project.content_plan_items.order(:deadline, :created_at)
    end

    def by_month
      y = params[:year].to_i
      m = params[:month].to_i

      # вычисляем границы месяца
      start_date = Date.new(y, m, 1)
      end_date   = start_date.end_of_month

      items = ContentPlanItem
        .joins(:project)
        .joins("LEFT JOIN project_specialists ON projects.id = project_specialists.project_id")
        .where(
          "(projects.creator_id = :uid OR project_specialists.user_id = :uid)
           AND content_plan_items.deadline BETWEEN :start_date AND :end_date",
          uid: current_user.id,
          start_date: start_date,
          end_date:   end_date
        )
        .includes(:project)
        .order(:deadline, :created_at)

      render json: items.map { |item|
        item.as_json(only: %i[id title posted deadline platform tags]).merge(
          project_name:  item.project.name,
          platform_name: item.platform_name,
          overdue:       item.overdue?,
          due_today:     item.due_today?
        )
      }
    end

    # GET /api/content_plan_items/:id
    def show
      render json: @content_plan_item
    end

    # POST /api/projects/:project_id/content_plan_items
    def create
      @content_plan_item = @project.content_plan_items.build(
        content_plan_item_params.except(:deadline)
      )
      @content_plan_item.deadline =
        next_deadline_for(@project, @content_plan_item.platform)

      if @content_plan_item.save
        render json: @content_plan_item, status: :created
      else
        render json: @content_plan_item.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/content_plan_items/:id
    def update
      if @content_plan_item.update(content_plan_item_params)
        render json: @content_plan_item
      else
        render json: @content_plan_item.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/content_plan_items/:id
    def destroy
      @content_plan_item.destroy
      head :no_content
    end

    # PATCH /api/content_plan_items/:id/toggle_posted
    def toggle_posted
      @content_plan_item.update(posted: !@content_plan_item.posted)
      render json: @content_plan_item
    end

        # GET /api/content_plan_items/today
    def today
      today_and_overdue_items = ContentPlanItem.joins(:project)
                                               .joins("LEFT JOIN project_specialists ON projects.id = project_specialists.project_id")
                                               .where(
                                                 "(projects.creator_id = ? OR project_specialists.user_id = ?) AND content_plan_items.deadline <= ? AND content_plan_items.posted = ?",
                                                 current_user.id,
                                                 current_user.id,
                                                 Date.current,
                                                 false
                                               )
                                               .includes(:project)
                                               .order(:deadline, :created_at)

      render json: today_and_overdue_items.map { |item|
        item.as_json.merge(
          project_name: item.project.name,
          platform_name: item.platform_name,
          overdue: item.overdue?,
          due_today: item.due_today?
        )
      }
    end

    private

    def authenticate_user!
      unless session[:user_id]
        render json: { error: 'Authentication required' }, status: :unauthorized
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def find_accessible_project
      @project = Project.joins("LEFT JOIN project_specialists ON projects.id = project_specialists.project_id")
                        .where(
                          "projects.id = ? AND (projects.creator_id = ? OR project_specialists.user_id = ?)",
                          params[:project_id],
                          current_user.id,
                          current_user.id
                        )
                        .first

      unless @project
        render json: { error: 'Project not found or access denied' }, status: :not_found
        return
      end
    end

    def find_accessible_content_plan_item
      @content_plan_item = ContentPlanItem.joins(:project)
                                          .joins("LEFT JOIN project_specialists ON projects.id = project_specialists.project_id")
                                          .where(
                                            "content_plan_items.id = ? AND (projects.creator_id = ? OR project_specialists.user_id = ?)",
                                            params[:id],
                                            current_user.id,
                                            current_user.id
                                          )
                                          .first

      unless @content_plan_item
        render json: { error: 'Content plan item not found or access denied' }, status: :not_found
        return
      end
    end

    def next_deadline_for(project, platform)
      schedule = project.schedule
      today    = Date.current

      # Если расписания нет или нет дней — просто сегодня
      return today unless schedule&.weekdays&.any?

      # Последний айтем по платформе (с самым большим дедлайном)
      last_item = project.content_plan_items
                         .where(platform: platform)
                         .where.not(deadline: nil)
                         .order(deadline: :desc)
                         .first

      # Откуда начинаем поиск:
      # — если есть последний дедлайн, то с day_after = last.deadline + 1
      # — иначе от schedule.start_date или today, что позже
      start_date =
        if last_item
          [last_item.deadline + 1.day, today].max
        else
          [schedule.start_date, today].max
        end

      # Преобразуем строковые дни в числа 0..6
      wday_map = {
        'sunday'    => 0,
        'monday'    => 1,
        'tuesday'   => 2,
        'wednesday' => 3,
        'thursday'  => 4,
        'friday'    => 5,
        'saturday'  => 6
      }
      desired_wdays = schedule.weekdays.map { |wd| wday_map[wd.downcase] }.compact

      # Просто бежим по дням, пока не найдём первый подходящий
      date = start_date
      loop do
        return date if desired_wdays.include?(date.wday)
        date = date.next_day
      end
    end

    def content_plan_item_params
      params.require(:content_plan_item)
            .permit(:title, :posted, :deadline, :platform, tags: [])
    end
  end
end
