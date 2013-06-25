class GroupsController < ApplicationController
	before_filter :authenticate_user!
	
	respond_to :json, :xml
	def show
		if(params[:id].blank?)
			render :json => { :error => 'the group id cannot be blank.'}
		else
			@group = Group.find_by_id(params[:id])
			if(@group.nil?)
				render :json => { :error => "the group do not exist."}
			else
				if(current_user.id == @group.user_id or @group.links.where("adherent_id = #{current_user.id}").count > 0)
					render :template => '/groups/show'
				else
					render :json => { :error => "you are not authorized to see that resource."}
				end
			end
		end
	end
	
	respond_to :json, :xml
	def create
		@name = params[:name]
		@user_id = current_user.id
		@category_id = params[:category_id]
		# if all parameters have not been provided
		if(nil_or_empty?(@name) or nil_or_empty?(@category_id))
			render :json => { :error => "please provide 'name, category_id' parameters."}
		else
			@user = current_user
			# if the user do not exist or its account is not published
			if(@user.nil? or (@user.published == false))
				render :json => { :error => "this user do not exist or is not published."}
			else
				@category = Category.find_by_id(@category_id.to_i)
				# if the category do not exist or is not published
				if(@category.nil? or (@category.published == false))
					render :json => { :error => "this category do not exist or is not published."}
				else
					# if the user already exists
					if(current_user.groups.find_by_name(capitalization(@name)) != nil)
						render :json => { :error => "this group already exist."}
					else
						Group.create(:name => capitalization(@name), :user_id => current_user.id, :category_id => @category_id.to_i)
						render :json => { :success => "the group has been created."}
					end
				end
			end
		end
	end
	
	respond_to :json, :xml
	def publish
		# if the id has not been provided
		if(params[:id].blank?)
			render :json => { :error => "the group id cannot be blank."}
		else
			@group = Group.find_by_id(params[:id])
			# if the group do not exist or has been deleted
			if(@group.nil? or (@group.deleted == true))
				render :json => { :error => "this group do not exist or has been deleted."}
			else
				if(current_user.id == @group.user_id)
					# if the group is not published
					if(@group.published == false)
						@group.update_attributes(:published => true)
						@message = 'the group has been published'
					else
						@group.update_attributes(:published => false)
						@message = 'the group has been unpublished'
					end
					render :json => { :success => @message}
				else
					render :json => { :error => "that group do not belong to this user."}
				end
			end
		end
	end
	
	respond_to :json, :xml
	def delete
		# if the id has not been provided
		if(params[:id].blank?)
			render :json => { :error => "the group id cannot be blank."}
		else
			@group = Group.find_by_id(params[:id])
			if(current_user.id == @group.user_id)
			# if the group do not exist or has already been deleted
				if(@group.nil? or (@group.deleted == true))
					render :json => { :error => "this group do not exist or has already been deleted."}
				else
					@group.update_attibutes(:deleted => true)
					render :json => { :success => "the group has been deleted."}
				end
			else
				render :json => { :error => "that group do not belong to this user."}
			end
		end
	end
	
	respond_to :json, :xml
	def get_category
		# if the id has not been provided
		if(nil_or_empty?(params[:id]))
			render :json => { :error => "the group id cannot be blank."}
		else
			@group = Group.find_by_id(params[:id])
			if(current_user.id == @group.user_id)
				# if the group do not exist or has already been deleted
				if(@group.nil?)
					render :json => { :error => "this group do not exist."}
				else
					@category = @group.category
					render :template => '/groups/category'
				end
			else
				render :json => { :error => "that group do not belong to this user."}
			end
		end
	end
	
	respond_to :json, :xml
	def show_active_links
		@group_id = params[:id]
		if(nil_or_empty?(@group_id))
			render :json => { :error => "the group id cannot be blank."}
		else
			if(group_is_published?(@group_id))
				if(current_user.id == @group.user_id)
					@links = Link.where("group_id = #{@group_id} AND deleted IS NOT FALSE")
					render :template => '/groups/show_active_links'
				else
					render :json => { :error => "that group do not belong to this user."}
				end
			else
				render :json => { :error => @message}
			end
		end
	end
	
end
