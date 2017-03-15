module AnalyticsHelper

	def is_number? string
  		true if Float(string) rescue false
	end

	def get_users(department_id)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			users = User.all.select { |user| user.department_id == department_id.to_i && user.user_level == "user_access"}
		else
			users = User.all.select { |user| user.user_level == "user_access"}
		end
		users 
	end

	def get_uni_modules(department_id, course_id)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil? && course_id != "any" && is_number?(course_id) && !Course.find(course_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i)) && uni_module.courses.include?(Course.find(course_id.to_i))}
		elsif department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i))}
		else
			uni_modules = UniModule.all
		end
		uni_modules
	end


	def get_day_difference(later_date, earlier_date)
		(later_date.to_date - earlier_date.to_date).to_i
	end

	def is_within_timeframe?(diffence_days, time_period)
		time_periods = Hash.new
		time_periods["day"] = 1
		time_periods["week"] = 7
		time_periods["month"] = 30
		time_periods["year"] = 365
		time_periods["all_time"] = (2**(0.size * 8 -2) -1)

		if diffence_days <= time_periods[time_period]	
			true
		else
			false
		end

	end


	# time period: day, week, month, year, all_time
	# sort by: most, least
	# number to show: how many to show

	# most/least reviewed modules
	def get_review_modules_analytics(department_id, course_id, time_period, sort_by, number_to_show)

		uni_modules_data = Hash.new
		users = get_users(department_id)
		uni_modules = get_uni_modules(department_id, course_id)
				
		users.each do |user|
			user.comments.each do |comment|
				if is_within_timeframe?(get_day_difference(Time.now, comment.created_at), time_period)
					uni_module = comment.uni_module
					if uni_modules.include?(uni_module)
						if uni_modules_data.key?(uni_module)
							uni_modules_data[uni_module] += 1
						else
							uni_modules_data[uni_module] = 1
						end
					end
				end
			end
		end
		
		# sort alphabetically
		uni_modules_data = uni_modules_data.sort_by {|_key, value| _key}

		# then sort based on request
		if sort_by == "least"
			uni_modules_data = uni_modules_data.sort_by {|_key, value| value}
		elsif
			uni_modules_data = uni_modules_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			uni_modules_data = uni_modules_data.first(number_to_show)
		end
		uni_modules_data
	end

	# most/least highly rated modules
	def get_rating_modules_analytics(department_id, course_id, time_period, sort_by, number_to_show)

		uni_modules_data = Hash.new
		users = get_users(department_id)
		uni_modules = get_uni_modules(department_id, course_id)
					
		users.each do |user|
			user.comments.each do |comment|
			if is_within_timeframe?(get_day_difference(Time.now, comment.created_at), time_period)
				uni_module = comment.uni_module
				if uni_modules.include?(uni_module)
					if uni_modules_data.key?(uni_module)
						uni_modules_data[uni_module] += comment.rating
						else
							uni_modules_data[uni_module] = comment.rating
						end
					end
				end
			end
		end
			
		# sort alphabetically
		uni_modules_data = uni_modules_data.sort_by {|_key, value| _key}

		# then sort based on request
		if sort_by == "least"
			uni_modules_data = uni_modules_data.sort_by {|_key, value| value}
		elsif
			uni_modules_data = uni_modules_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			uni_modules_data = uni_modules_data.first(number_to_show)
		end
			uni_modules_data
	end

	# most/least active courses
	def get_active_courses(department_id, time_period, sort_by, number_to_show)
		courses_data = Hash.new
		users = get_users(department_id)

		users.each do |user|
			course = Course.find(user.course_id)
			if is_within_timeframe?(get_day_difference(Time.now, user.last_login_time), time_period)
				if courses_data.key?(course)
					courses_data[course] += 1
				else
					courses_data[course] = 1
				end	
			end
		end


		# sort alphabetically
		courses_data = courses_data.sort_by {|_key, value| _key}

		# then sort based on request
		if sort_by == "least"
			courses_data = courses_data.sort_by {|_key, value| value}
		elsif
			courses_data = courses_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			courses_data = courses_data.first(number_to_show)
		end
			courses_data

	end

	# most/least active department
	def get_active_departments(time_period, sort_by, number_to_show)
		departments_data = Hash.new
		users = get_users("any")

		users.each do |user|
			department = Department.find(user.department_id)
			if is_within_timeframe?(get_day_difference(Time.now, user.last_login_time), time_period)
				if departments_data.key?(department)
					departments_data[department] += 1
				else
					departments_data[department] = 1
				end	
			end
		end


		# sort alphabetically
		departments_data = departments_data.sort_by {|_key, value| _key}

		# then sort based on request
		if sort_by == "least"
			departments_data = departments_data.sort_by {|_key, value| value}
		elsif
			departments_data = departments_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			departments_data = departments_data.first(number_to_show)
		end
			departments_data

	end




end