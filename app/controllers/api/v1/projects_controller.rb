# app/controllers/api/v1/projects_controller.rb
class Api::V1::ProjectsController < Api::V1::MayEditController
    # class for Controller
    def index
        projects = if params[:name]
                       Project.where(name: params[:name]).first
                   elsif params[:user_id]
                       Project.where(user_id: params[:user_id])
                   elsif params[:featured]
                       Project.where(featured: true)
                   else
                       Project.where(published: true)
                   end

        render json: projects
    end

    def show
        authenticate! do
            @project = Project.find(params[:id])
            # Only return the project if it is published, the user is the owner
            # or the user is a collaborator.
            if @project.published == true || may_edit(@project) == true
                render json: @project, root: 'project'
            else
                head 401
            end
        end
    end

    def create
        authenticate! do
            project = Project.new(project_params)
            if @current_login
                if project.save
                    # Ember wants some JSON
                    render json: project, status: 201
                else
                    head 500
                end
            else
                head 401
            end
        end
    end

    def update
        @project = Project.find(params[:id])
        if may_edit(@project) == true
            if @project.update(project_params)
                render json: {}, status: 204
            else
                head 500
            end
        else
            head 401
        end
    end

    def destroy
        project = Project.find(params[:id])
        if may_edit(project)
            project.destroy
            head 204
        else
            head 401
        end
    end

    private

    def project_params
        params.require(:project).permit(
            :name, :saved, :description, :center_lat, :center_lng, :zoom_level,
            :default_base_map, :user_id, :published, :featured, :intro, :media,
            :photo, :template_id
        )
    end
end
