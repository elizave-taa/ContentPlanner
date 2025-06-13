module Api
  class ProjectsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :archive, :update_cover, :join_project]

    # POST /api/projects
    def create
      @project = Project.new(project_params)
      @project.creator_id = current_user.id

      if @project.save
        render json: @project, include: [
          :project_photos,
          :project_map_links,
          :project_design_links,
          :project_reference_links,
          :project_files,
          :content_plan_items,
          :specialists,
          :schedule,
          :creator
        ], status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/projects/:id
    def update
      @project = Project.find(params[:id])
      unless @project.creator_id == current_user.id || @project.specialists.include?(current_user)
        render json: { error: 'Permission denied' }, status: :forbidden and return
      end
      if @project.update(project_params)
        render json: @project, include: [
          :project_photos,
          :project_map_links,
          :project_design_links,
          :project_reference_links,
          :project_files,
          :content_plan_items,
          :specialists,
          :schedule,
          :creator
        ]
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # GET /api/projects
    def index
      projects = Project.where('creator_id = ? OR id IN (SELECT project_id FROM project_specialists WHERE user_id = ?)',
                             current_user.id, current_user.id)
      render json: projects, include: [ :specialists, :creator ]
    end

    # GET /api/projects/:id
    def show
      @project = Project.find(params[:id])
      unless @project.creator_id == current_user.id || @project.specialists.include?(current_user)
        render json: { error: 'Permission denied' }, status: :forbidden and return
      end
      @project.ensure_valid_code! # Generate new code if needed

      render json: @project, include: [
        :project_photos,
        :project_map_links,
        :project_design_links,
        :project_reference_links,
        :project_files,
        :content_plan_items,
        :specialists,
        :schedule,
        :creator
      ]
    end

    # DELETE /api/projects/:id
    def destroy
      @project = Project.find(params[:id])
      unless @project.creator_id == current_user.id || @project.specialists.include?(current_user)
        render json: { error: 'Permission denied' }, status: :forbidden and return
      end
      @project.destroy
      head :no_content
    end

    # PATCH /api/projects/:id/archive
    def archive
      @project = Project.find(params[:id])
      unless @project.creator_id == current_user.id || @project.specialists.include?(current_user)
        render json: { error: 'Permission denied' }, status: :forbidden and return
      end
      if @project.update(is_archived: params[:is_archived])
        render json: @project, include: [
          :project_photos,
          :project_map_links,
          :project_design_links,
          :project_reference_links,
          :project_files,
          :content_plan_items,
          :specialists,
          :schedule,
          :creator
        ], status: :ok
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # PATCH /api/projects/:id/update_cover
    def update_cover
      @project = Project.find(params[:id])
      unless @project.creator_id == current_user.id || @project.specialists.include?(current_user)
        render json: { error: 'Permission denied' }, status: :forbidden and return
      end
      if @project.update(cover: params[:cover])
        render json: {
          id: @project.id,
          cover: @project.cover ? Base64.encode64(@project.cover) : nil,
          coverUrl: @project.cover ? "data:image/jpeg;base64,#{Base64.encode64(@project.cover)}" : nil
        }, status: :ok
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # POST /api/projects/join
    def join_project
      @project = Project.find_by_valid_code(params[:code])

      if @project.nil?
        render json: { error: 'Invalid or expired code' }, status: :not_found
        return
      end

      current_user = User.find(session[:user_id])

      if @project.specialists.include?(current_user) || @project.creator_id == current_user.id
        render json: { error: 'You are already a specialist on this project' }, status: :unprocessable_entity
        return
      end

      @project.specialists << current_user

      render json: @project, include: [
        :project_photos,
        :project_map_links,
        :project_design_links,
        :project_reference_links,
        :project_files,
        :content_plan_items,
        :specialists,
        :schedule,
        :creator
      ], status: :ok
    end

    private

    def project_params
      params.require(:project).permit(
        :name, :description, :cover, :url, :telegram_url, :instagram_url, :vkontakte_url, :youtube_url, :tiktok_url, :yandex_zen_url,
        project_photos_attributes: [:id, :url, :title, :_destroy],
        project_map_links_attributes: [:id, :url, :_destroy],
        project_design_links_attributes: [:id, :url, :_destroy],
        project_reference_links_attributes: [:id, :url, :_destroy],
        project_files_attributes: [:id, :filename, :data, :_destroy],
        content_plan_items_attributes: [:id, :title, :posted, :deadline, :platform, :_destroy, tags: []],
        schedule_attributes: [:id, :start_date, :weekdays]
      )
    end
  end
end
