class DashboardController < ApplicationController
  def home
    @requests = current_user.requests
    @memberships = current_user.memberships
  end

  private

end
