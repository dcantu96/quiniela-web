class PicksController < ApplicationController
  before_action :set_pick, only: [:update]

  def update
    respond_to do |format|
      if @pick.updatable? && @pick.update(pick_params)
        if pick_params[:points].present?
          format.turbo_stream { flash.now[:notice] = "Monday night score successfully set to #{@pick.points}" }
          format.html { redirect_to picks_membership_path(@pick.membership_week.membership), notice: "Monday night score successfully set to #{@pick.points}" }
        else
          format.turbo_stream { flash.now[:notice] = "Pick successfully set to #{@pick.picked_team.short_name}" }
          format.html { redirect_to picks_membership_path(@pick.membership_week.membership), notice: "Pick successfully set to #{@pick.picked_team.short_name}" }
        end
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
