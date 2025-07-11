class Admin::PicksController < Admin::BaseController
  before_action :set_pick, only: [:update]

  def update
    respond_to do |format|
      if @pick.update pick_params
        format.html { redirect_to picks_admin_group_membership_path(@pick.membership_week.membership.group, @pick.membership_week.membership), notice: "Monday night score successfully set to #{@pick.points}" }
        format.js
      else
        format.js { render 'error' }
      end
    end
  end

  private

  def set_pick
    @pick = Pick.find(params[:id])
  end

  def pick_params
    params.require(:pick).permit :picked_team_id, :points, :modified_by_admin
  end
end
