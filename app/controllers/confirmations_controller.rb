# app/controllers/confirmations_controller.rb
class ConfirmationsController < Devise::ConfirmationsController

# GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:success, :confirmed) if is_navigational_format?
      sign_in(resource)
      redirect_to resource
      #respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

  def new
    super
  end

  def create
    super
  end

end