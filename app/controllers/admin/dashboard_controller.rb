class Admin::DashboardController < Admin::BaseController
  def home
    @requests = current_user.requests
    @memberships = current_user.memberships
  end

  private

end
