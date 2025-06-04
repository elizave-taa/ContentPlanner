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

    # GET /api/content_plan_items/:id
    def show
      render json: @content_plan_item
    end

    # POST /api/projects/:project_id/content_plan_items
    def create
      @content_plan_item = @project.content_plan_items.build(content_plan_item_params)

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

    def content_plan_item_params
      params.require(:content_plan_item).permit(:title, :posted, :deadline, :platform, tags: [])
    end
  end
end
