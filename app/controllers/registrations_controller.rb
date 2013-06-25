class RegistrationsController < Devise::RegistrationsController
    
  # POST /resource
  respond_to :json, :xml
  def create
    build_resource
    @firstname = params[:firstname]
    @lastname = params[:lastname]
    @gender = params[:gender]
    @msisdn = params[:msisdn]
    @prefix = params[:prefix]
	
		if (params[:email].blank? or params[:password].blank? or @firstname.blank? or @lastname.blank? or !valid_gender?(@gender) or !valid_msisdn?(@msisdn) or !valid_prefix?(@prefix))
			#clean_up_passwords(resource)
		  #respond_with_navigational(resource) { render_with_scope :new }
		  render :json => { :error => "please provide 'firstname, lastname, gender, msisdn, prefix' parameters."}
		else
			resource.email = params[:email]
			resource.password = params[:password]
			resource.password_confirmation = params[:password]
		  if resource.save
		  	resource.update_attributes(:firstname => capitalization(@firstname), :lastname => capitalization(@lastname), :gender => capitalization(@gender), :prefix => @prefix, :msisdn => @msisdn)
		  	resource.reset_authentication_token!
		    if resource.active_for_authentication?
		      sign_in(resource)          
          render :template => '/devise/registrations/signed_up'
		    else
		      #set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?	      		      		      
		      expire_session_data_after_sign_in!
		      render :json => { :warning => "your account is inactive, the confirmation token has been sent by mail."}
		      #redirect_to new_user_registration_path
		      #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
		    end
		  else
		    p resource.errors
		    render :json => { :error => resource.errors}
        #render :template => '/devise/registrations/new'
		  end
		end
  end
  
end
