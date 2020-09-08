class Admin::MatchesController < Admin::BaseController
  before_action :set_match, only: [:update, :show, :edit]

  def index
    @matches = Match.all
  end

  def new
    @week = Week.find(params[:week_id])
    @match = Match.new
  end

  def show
  end

  def edit
  end

  def create
    @match = Match.new match_params
    if @match.save
      redirect_to admin_week_path(@match.week), notice: 'Match created successfully'
    else
      redirect_to new_admin_match_path, alert: @match.errors.full_messages.first
    end       
  end

  def update
    if @match.update match_params
      redirect_to admin_week_path(@match.week), notice: 'Match updated successfully'
    else
      redirect_to edit_admin_match_path(@match), alert: @match.errors.full_messages.first
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params
      .require(:match)
      .permit :start_time, :week_id, :visit_team_id, :home_team_id,
              :winning_team_id, :untie, :premium, :visit_team_score,
              :home_team_score
  end
end
