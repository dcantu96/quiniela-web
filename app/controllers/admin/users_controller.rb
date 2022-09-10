class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show]
  layout 'admin'

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def show; end

  private
  
  def set_user
    @user = User.find_by(id: params[:id])
  end
end
