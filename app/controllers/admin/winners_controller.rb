class Admin::WinnersController < Admin::BaseController

  def create
    @winner = Winner.new winner_params
    if @winner.save
      redirect_to winners_admin_group_path(@winner.membership_week.membership.group)
    else
      redirect_to winners_admin_group_path(MembershipWeek.find(winner_params[:membership_week_id]).membership.group)
    end       
  end

  private

  def winner_params
    params.require(:winner).permit :membership_week_id
  end
end
