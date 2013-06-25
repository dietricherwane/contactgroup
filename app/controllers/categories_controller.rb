class CategoriesController < ApplicationController
	
	# retrieves all categories
	respond_to :json, :xml
	def index
		@categories = Category.all
	end
	
	# retrieves published categories
	respond_to :json, :xml
	def published
		@categories = Category.where("published IS NOT false")
	end
	
	# publish or unpublish a category
	respond_to :json, :xml
	def publish
		# if the param id is null or empty
		if(params[:id].blank?)
			render :json => { :error => 'the category id cannot be blank.'}
		else
			@category = Category.find_by_id(params[:id])
			# if the category do not exist
			if(@category.nil?)
				render :json => { :error => 'category do not exist.'}
			else
				# if the category is not published
				if(@category.published == false)
					@category.update_attributes(:published => true)
					@message = 'the category has been published'
				else
					@category.update_attributes(:published => false)
					@message = 'the category has been unpublished'
				end
				render :json => { :success => @message}
			end
		end
	end
	
	# show a category by its id
	respond_to :json, :xml
	def show
		if(params[:id].blank?)
			render :json => { :error => 'the category id cannot be blank.'}
		else
			@category = Category.find_by_id(params[:id])
			if(@category.nil?)
				render :json => { :error => 'category do not exist.'}
			else
				render :template => '/categories/show'
			end		
		end
	end
end
