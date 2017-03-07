module Admin
  class UploadController < Admin::ApplicationController
   
    def upload
    end

    def download
      resource_name = params[:resource_choice]
      resource = nil

      Administrate::Namespace.new(namespace).resources.each do |administrate_resource|
        if administrate_resource.to_s == resource_name
          resource = administrate_resource
        end
      end

      logger.debug(resource)

      resource_header = []

      case resource.to_s
        when "courses"
          resource_header = Course.attribute_names
        when "departments"
          resource_header = Department.attribute_names
        when "faculties"
          resource_header = Faculty.attribute_names
        when "uni_modules"
          resource_header = UniModule.attribute_names
        when "users"
          resource_header = User.attribute_names
        when "year_structures"
          resource_header = YearStructure.attribute_names
      end

      logger.debug(resource_header)

      require 'csv'
      CSV.open("#{resource_name}_upload.csv", "wb") do |csv|
        csv << resource_header
      end

      # CSV.foreach("#{resource_name}_upload.csv") do |row|
      #   logger.debug(row)
      # end

      head :no_content
    end

  end
end
