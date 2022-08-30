class DashboardController < ApplicationController
  def home
    @requests = current_user.requests.includes(:account, group: [:tournament])
    @active_groups = current_user.groups.active
    @active_memberships = current_user.memberships.active
    @finished_memberships = current_user.memberships.finished.includes(:account, group: [:tournament])
    @groups = Group.active
    @accounts = current_user.accounts
    @can_join_more_groups = (@active_groups.length + @requests.pending.length < @groups.length || @accounts.inactive.present?) && @accounts.present?
  end

  def join_groups
    @requests = current_user.requests
    @memberships = current_user.memberships
    @empty_groups = Group.includes(:membership).where.not(memberships: @memberships)
  end
end
