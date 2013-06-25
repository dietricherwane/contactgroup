class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :after_token_authentication
	
	def after_token_authentication
    if params[:authentication_key].present?
      @user = User.find_by_authentication_token(params[:authentication_key]) # we are finding the user with 			the authentication_key with which devise has authenticated the user
      sign_in @user if @user # we are siging in user if it exist. sign_in is devise method to sigin in any user
      #redirect_to root_path # now we are redirecting the user to root_path i,e our home page
    end
  end
  
  def capitalization(raw_string)
  	@string_capitalized = ''
  	raw_string.split.each do |name|
  		@string_capitalized << "#{name.capitalize} "
  	end
  	@string_capitalized.strip
  end
  
  def is_not_a_number?(n)
  	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false 
	end
	
	# used to check if provided parameters are null or empty
	def nil_or_empty?(parameter)
		if(parameter.nil?)
			true
		else
			if(parameter.class == "String")
				if(parameter.empty?)
					true
				else
					false
				end
			else
				false
			end
		end
	end
	
	# used to check if a group exists and is published
	def group_is_published?(group_id)
		@group = Group.find_by_id(group_id)
		if(!@group.nil? && @group.published != false)
			true
		else
			@message = 'this group do not exist or is not published.'
			false
		end
	end
	
	# used to check if a user exists and is published
	def user_is_published?(user_id)
		@user = User.find_by_id(user_id)
		if(!@user.nil? && @user.published != false)
			true
		else
			@message = 'this user do not exist or is not published.'
			false
		end
	end
	
	# used to check if the hash is a valid JSON object
	def valid_hash?(hash)
		if(hash.class.to_s == "ActiveSupport::HashWithIndifferentAccess" and hash.size > 0)
			@message = "please provide a valid json object."
			true
		else
			false
		end
	end
	
	# used to check if a prefix has a length of 3
	def valid_prefix?(prefix)
		if(is_not_a_number?(prefix) or prefix.to_s.length != 3)
			@message = 'please check the parameters.'
			false
		else
			true
		end
	end		
	
	# used to check if a phone numer is valid
	def valid_msisdn?(msisdn)
		if(is_not_a_number?(msisdn) or msisdn.to_s.length < 5)
			@message = 'please check the parameters.'
			false
		else
			true
		end
	end
	
	# used to check if a gender is valid
	def valid_gender?(gender)
		if(gender.blank?)
			false
		else
			if(gender.casecmp("m") or gender.casecmp("f"))
				true
			else
				false
			end
		end
	end
	
	# used to check if an id is valid
	def valid_id?(id)
		if(is_not_a_number?(id))
			@message = 'please check the parameters.'
			false
		else
			true
		end
	end
	
	# used to check if a demand exists
	def demand_exists?(id)
		@demand = Demand.find_by_id(id)
		if(@demand.nil?)
			@message = "that demand do not exist."
			false
		else
			true
		end
	end
	
	# used to check if a demand can be accepted
	def demand_acceptable?(demand, receiver_id)
		@user = User.find_by_id(receiver_id)
		if(@user.prefix == demand.prefix and @user.msisdn == demand.msisdn)
			if(demand.accepted.nil?)
				if((DateTime.now - demand.created_at.to_date).days < Parameter.first.demand_expiration_delay.days)
					if(user_is_published?(demand.user_id))
						if(group_is_published?(demand.group_id))
							true
						else
							@message = 'this group do not exist or is not published.'
							false
						end
					else
						@message = 'this user do not exist or is not published.'
						false
					end
				else
					@message = "the demand acceptation delay has expired."
					false
				end
			else
				if(demand.accepted)
					@status = "accepted."
				else
					@status = "rejected."
				end
				@message = "that demand has already been #{@status}"
				false
			end
		else
			@message = "that demand do not belong to this user."
			false
		end
	end
	
	# used to check if a demand can be created
	def demand_creatable?(group_id, user, prefix, msisdn)
		@message = ''
		if(user.prefix == prefix.to_s && user.msisdn == msisdn.to_s)
			@message = 'you cannot send a demand to yourself.'
			false
		else
			@demand = Demand.where("group_id = #{group_id} AND user_id = #{user.id} AND prefix = '#{prefix}' AND msisdn = '#{msisdn}'").order("created_at DESC")
			# if a demand with this group_id, user_id, prefix and numbers exists
			if(@demand.count > 0)
				@demand = @demand.first
				# if the demand has already been accepted
				if(@demand.accepted == true)
					@message = 'this demand has already been accepted.'
					false
				else
					# if the demand has not been accepted
					if(@demand.accepted == false)
						# if the delay before resending a demand has already expired
						if((DateTime.now - @demand.created_at.to_date).days > Parameter.first.delay_before_resending_demand.days)
							true
						else
							@message = 'the delay before resending a demand has not expired yet.'
							false
						end
					# if the demand has not been accepted nor rejected
					else
						# if more than 7 days have passed since the demand was sent
						if((DateTime.now - @demand.created_at.to_date).days > Parameter.first.demand_expiration_delay.days)
							true
						else
							@message = 'the demand acceptation delay has not expired yet.'
							false
						end
					end
				end
			else
				true
			end
		end
	end
	
end
