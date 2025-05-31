module Api
  class ProjectsController < ApplicationController
    # POST /api/projects
    def create
      @project = Project.new(project_params)
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/projects/:id
    def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
        render json: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # GET /api/projects
    def index
      render json: Project.all
    end

    # GET /api/projects/:id
    def show
      render json: Project.find(params[:id])
    end

    # DELETE /api/projects/:id
    def destroy
      @project = Project.find(params[:id])
      @project.destroy
      head :no_content
    end

    private

    def project_params
      params.require(:project).permit(
        :name, :description, :telegram_url, :instagram_url, :vkontakte_url, :youtube_url, :tiktok_url, :yandex_zen_url,
        project_photos_attributes: [:id, :url, :title, :_destroy],
        project_map_links_attributes: [:id, :url, :_destroy],
        project_design_links_attributes: [:id, :url, :_destroy],
        project_reference_links_attributes: [:id, :url, :_destroy],
        project_files_attributes: [:id, :filename, :data, :_destroy]
      )
    end
  end
end
