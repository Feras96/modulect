module Admin
  class GroupsController < Admin::BaseController

  	def index
  	end

  	def edit
      @group = Group.find(params[:id])
  	end

  	def update
      @group = Group.find(params[:id])
      if @group.update_attributes group_params
        flash[:notice] = "#{@group.name} successfully updated."
        redirect_to edit_admin_year_structure_path(@group.year_structure)
      else
        render 'edit'
      end
  	end

  	def destroy
  	end

    private
    def group_params
      params.require(:group).permit(:name, :total_credits, :compulsory, uni_module_ids: [])
    end

  end
end
