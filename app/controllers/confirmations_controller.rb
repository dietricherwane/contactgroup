class ConfirmationsController < Devise::ConfirmationsController
  include Devise::Controllers::InternalHelpers

  # GET /resource/confirmation/new
  def new
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/confirmation
  respond_to :json, :xml
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if successfully_sent?(resource)
      #respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
      render :json => { :success => "confirmation instrauctions has been sent."}
    else
      render :json => { :success => "something wrong happened."}
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  respond_to :json, :xml
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      #set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      #respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      #render :template => '/devise/registrations/signed_up'
      #render :json => { :success => :confirmed}
      render :template => '/devise/registrations/signed_up'
    else
      #respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render_with_scope :new }
      render :json => { :error => resource.errors}
    end
  end

  protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      after_sign_in_path_for(resource)
    end

end
