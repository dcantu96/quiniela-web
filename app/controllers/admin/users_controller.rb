class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show]
  layout 'admin'

  def index
    @users = User.all
  end
end
