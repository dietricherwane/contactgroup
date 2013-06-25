class UsersController < ApplicationController
	before_filter :authenticate_user!
 
  respond_to :json, :xml
  def show
    @user = User.find_by_id(current_user.id)
  end
  
  respond_to :json, :xml
  def index
  	@users = User.all
  end
  
  respond_to :json, :xml
  def profile
  	@user = User.find_by_id(current_user.id)
  	if(@user.nil?)
  		render :json => { :error => 'user do not exist.'}
  	else
  		render :template => '/users/profile'
  	end
  end
  
  respond_to :json, :xml
	def pending_demands
		@receiver_id = current_user.id
		if(nil_or_empty?(@receiver_id))
			render :json => { :error => "please provide 'receiver_id' parameter." }
		else
			if(user_is_published?(@receiver_id))
				@receiver = @user
				@demands = Demand.where("prefix = '#{@receiver.prefix}' AND msisdn = '#{@receiver.msisdn}' AND accepted IS NULL AND ((created_at + interval '7' day) > CURRENT_TIMESTAMP)").order("created_at DESC")
				render :template => '/users/pending_demands'
			else
				render :json => { :error => "this user do not exist or is not published." }
			end
		end
	end
		
end
