module Admin
  class DepartmentsController < Admin::BaseController
    before_action :verify_super_admin, only: [:destroy, :new, :create, :update, :edit, :index,]

    def show
      redirect_to edit_admin_department_path(params[:id])
    end
    
    # the customised advanced index action handles the displaying of the correct records for the user level, the pagination, the search and the sorting by the columns specified in the view
  	def index      
      # show correct records based on user level
      if params[:faculty].present? && params[:faculty].to_i != 0 && Faculty.exists?(params[:faculty].to_i)
          @faculty_filter_id = params[:faculty].to_i
          @departments = Faculty.find(@faculty_filter_id).departments
        else
          @departments = Department.all 
        end
      
      # if user has changed per_page, change it else use the default of 20
      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      # if the user is searching look for records which match the search query and paginate accordingly
      if params[:search].present?
        @search_query = params[:search]
        @departments = @departments.select { |department| department.name.downcase.include?(params[:search].downcase) }.sort_by{|department| department[:name]}
        @departments = Kaminari.paginate_array(@departments).page(params[:page]).per(@per_page) 

      # if the user wasn't search but was sorting get the records and sort accordingly
      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @departments = sort(Department, @departments, @sort_by, @order, @per_page, "name")
        @departments = Kaminari.paginate_array(@departments).page(params[:page]).per(@per_page)

      # default record view
      else
         @departments = @departments.order('name ASC').page(params[:page]).per(@per_page)
      end

      if @departments.size == 0 && params[:page].present? && params[:page] != "1"
        redirect_to admin_departments_path
      end

      # handles the csv export
      if current_user.user_level == "super_admin_access"


        @departments_to_export = @departments
        if params[:export].present?
          export_departments_ids_string = params[:export]
          export_departments_ids = eval(export_departments_ids_string)

          @departments_to_export = Department.where(id: export_departments_ids)
          @departments_to_export = @departments_to_export.order('LOWER(name) ASC')  
        else
          @departments_to_export = @departments
        end

         respond_to do |format|
          format.html
          format.csv {send_data @departments_to_export.to_csv}
        end

      end

    end

    # default new action for departments
    def new
      @department = Department.new
    end

    def create
      # Instantiate a new object using form parameters
      @department = Department.new(department_params)
      # Save the object
      if @department.save
        # If save succeeds, redirect to the index action
        flash[:success] = "Succesfully created #{@department.name}"
        redirect_to(admin_departments_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render("admin/departments/new")

      end
    end

    def edit
      #! allows for template's form to be ready populated with the associated users data ready for modification by admin
      @department = Department.find(params[:id])
    end

    def update
      # Find a  object using id parameters
      @department = Department.find(params[:id])
      # Update the object
      if @department.update_attributes(department_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @department.name
        redirect_to(admin_departments_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/departments/edit')
      end
    end

  	def destroy
      @department = Department.find(params[:id])
      # check for constraints
      if has_no_course_dependacies && has_no_uni_module_dependacies
        #delete tuple object from db
        @department.users.each do |user|
          user.update_attribute("department_id", nil)
        end

        PathwaySearchLog.where(department_id: @department.id).destroy_all
        Notice.where(department_id: @department.id).destroy_all
        SearchLog.where(department_id: @department.id).destroy_all
        TagLog.where(department_id: @department.id).destroy_all
        VisitorLog.where(department_id: @department.id).destroy_all

        @department.destroy
        flash[:success] = "Successfully deleted " + @department.name
      else
        flash[:error] = @department.name+" is linked to a course/module. You must first either unlink or delete those modules."
      end
      #redirect to action which displays all departments
      redirect_to admin_departments_path
    end

    # handles the bulk deletion of courses and any logs which may reference this course    
    def bulk_delete
      department_ids_string = params[:ids]
      department_ids = eval(department_ids_string)

      department_ids.each do |id|
        department = Department.find(id.to_i)
        
          if !department.nil? && department.courses.empty? && department.uni_modules.empty?
             department.users.each do |user|
                user.update_attribute("department_id", nil)
            end
            PathwaySearchLog.where(department_id: department.id).destroy_all
            Notice.where(department_id: department.id).destroy_all
            SearchLog.where(department_id: department.id).destroy_all
            TagLog.where(department_id: department.id).destroy_all
            VisitorLog.where(department_id: department.id).destroy_all
            department.destroy
          end
        
      end

      head :no_content
    end


    # handles the clone bulk action by copying all of a department's attributes. if a record already has been cloned (and is tried to be recloned) then an error is shown
    def clone 
      department_ids_string = params[:ids]
      department_ids = eval(department_ids_string)

      department_ids.each do |id|
        department = Department.find(id.to_i)
        
          if !department.nil?
            if Department.exists?(name: department.name + "-CLONE")
              flash[:error] = "Some records have already been cloned and cannot be recloned."
            else
              cloned = department.dup
              cloned.update_attribute("name", cloned.name + "-CLONE")
            end
          end
        
      end

      head :no_content
    end

    private

      def department_params
        #!add params that want to be recognized by this application
        params.require(:department).permit(:faculty_id,:name,:course_ids=>[])
      end

        # checks no uni module is linked to it already
        def has_no_uni_module_dependacies
          @department.uni_modules.empty??true:false
        end


        # checks no course is linked to it already
      def has_no_course_dependacies
        @department.courses.empty??true:false
      end
      
      # verify that the current user is a super admin otherwise redirect away
      def verify_super_admin
         redirect_to admin_path unless current_user.user_level == "super_admin_access"

      end
  end
end
