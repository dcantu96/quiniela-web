class PicksController < ApplicationController
  before_action :set_pick, only: [:update]

  def update
    respond_to do |format|
      if @pick.update pick_params
        format.js
      end
    end
  end

  private

  def set_pick
    @pick = Pick.find(params[:id])
  end

  def pick_params
    params.require(:pick).permit :picked_team_id
  end
end
