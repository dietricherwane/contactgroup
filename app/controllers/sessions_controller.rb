class SessionsController < Devise::SessionsController
  before_filter :authenticate_user!#, :only => [:destroy]
	
	# POST /resource/sign_in
	respond_to :json, :xml
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    sign_in(resource_name, resource)
    render :template => '/devise/registrations/signed_up'
  end  
  
  respond_to :json, :xml
  def destroy
    if(current_user.blank?)
    	render :json => { :error => "you need to sign in first."}
    else
		  current_user.reset_authentication_token!
		  render :json => { :success => "you are now signed out."}
    end
  end
end
