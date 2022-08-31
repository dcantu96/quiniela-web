class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :set_time_zone, if: :current_user

  def after_invite_path_for(resource)
    edit_user_registration_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :phone, :time_zone])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone, :time_zone])
  end

  private

  def user_not_authorized
    flash[:error] = 'No tienes acceso'
  end

  def set_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end
end
