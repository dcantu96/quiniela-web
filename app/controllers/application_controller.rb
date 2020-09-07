class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_invite_path_for(resource)
    edit_user_registration_path
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    else
      root_path
    end
  end

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :phone])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone])
  end

  private

  def user_not_authorized
    flash[:error] = 'No tienes acceso'
  end
end
