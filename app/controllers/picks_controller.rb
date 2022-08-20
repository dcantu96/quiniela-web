class PicksController < ApplicationController
  before_action :set_pick, only: [:update]

  def update
    respond_to do |format|
      if @pick.updatable? && @pick.update(pick_params)
        if @pick.match.untie
          format.html { redirect_to picks_membership_path(@pick.membership_week.membership), notice: "Monday night score successfully set to #{@pick.points}" }
        else
          format.html { redirect_to picks_membership_path(@pick.membership_week.membership), notice: "Pick successfully set to #{@pick.picked_team.short_name}" }
        end
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
