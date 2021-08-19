class DashboardController < ApplicationController
  def home
    @requests = current_user.requests
    @memberships = current_user.memberships
    @empty_groups = Group.includes(:membership).where.not(memberships: @memberships)
  end

  private

end
