class Admin::DashboardController < Admin::BaseController
  def home
    @groups = Group.all
    @requests = current_user.requests
    @memberships = current_user.memberships
  end

  private

end
