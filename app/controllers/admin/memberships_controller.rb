class Admin::MembershipsController < Admin::BaseController
  before_action :set_membership, only: [:show]

  def show
    @current_week_picks = @membership.current_week_picks
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
