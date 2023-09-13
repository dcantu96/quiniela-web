class DashboardController < ApplicationController
  def home
    @requests = current_user.requests.includes(:account, group: [:tournament])
    requested_group_ids = current_user.requests.pluck(:group_id)
    @joinable_groups = Group.joinable.where.not(id: current_user.groups).where.not(id: requested_group_ids)
    @active_memberships = current_user.memberships.active
    @finished_memberships = current_user.memberships.finished.includes(:account, group: [:tournament])
    @accounts = current_user.accounts
    @latest_post = BlogPost.published.last
  end

  def join_groups
    @requests = current_user.requests
    @memberships = current_user.memberships
    @empty_groups = Group.includes(:membership).where.not(memberships: @memberships)
  end
end
