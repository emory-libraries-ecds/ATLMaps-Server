# app/controllers/api/v1/projects_controller.rb
class Api::V1::ProjectsController < Api::V1::PermissionController
    # class for Controller
    include RailsApiAuth::Authentication
    def index
        projects = if params[:name]
                       Project.where(name: params[:name]).first
                   elsif params['user_id'] && current_user
                       Project.where(user_id: current_user.user.id)
                   elsif params[:featured]
                       Project.where(featured: true)
                   elsif params[:collaborations]
                       Project.joins(:collaboration).where(\
                           collaborations: { user_id: params[:collaborations] }
                       )
                   else
                       Project.featured
                   end

        render json: projects
    end

    def show
        project = Project.find(params[:id])
        # Only return the project if it is published, the user is the owner
        # or the user is a collaborator.
        permissions = ownership(project)
        if project.published == true || permissions[:may_edit] == true
            render json: project, root: 'project', may_edit: permissions[:may_edit], mine: permissions[:mine]
        else
            render json: { errors: 'permission denied' }.to_json, status: 401
        end
    end

    def create
        if current_user && current_user.confirmed
            # project_params['user_id'] = current_user.user.id
            project = Project.new(project_params)
            project.user = current_user.user
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

    def update
        project = Project.find(params[:id])
        permissions = ownership(project)
        if permissions[:may_edit] == true
            if project.update(project_params)
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
        permissions = ownership(project)
        if permissions[:mine]
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
            :default_base_map, :published, :featured, :intro, :media,
            :photo
        )
    end
end
