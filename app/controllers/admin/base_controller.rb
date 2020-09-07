class Admin::BaseController < ApplicationController
  layout 'admin' 
  before_action :require_admin

  def require_admin
    redirect_to after_sign_in_path_for(current_user) unless current_user.admin?
  end
end