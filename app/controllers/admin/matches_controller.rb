class Admin::MatchesController < Admin::BaseController
  before_action :set_match, only: [:update, :show, :edit, :set_winner, :fetch_winner, :destroy]

  def index
    @matches = Match.all
  end

  def new
    @week = Week.find(params[:week_id])
    @match = Match.new
  end

  def show; end

  def edit
    if @match.home_team_id && @match.visit_team_id
      @match_teams = Team.where(id: [@match.home_team_id, @match.visit_team_id])
    end
  end

  def create
    @match = Match.new match_params
    if @match.save
      redirect_to admin_week_path(@match.week), notice: 'Match created successfully'
    else
      redirect_to new_admin_week_match_path(@match.week), alert: @match.errors.full_messages.first
    end       
  end

  def update
    if @match.update match_params
      redirect_to admin_week_path(@match.week), notice: 'Match updated successfully'
    else
      redirect_to edit_admin_match_path(@match), alert: @match.errors.full_messages.first
    end
  end

  def destroy
    if @match.destroy
      redirect_to admin_week_path(@match.week), notice: 'Match destroyed successfully'
    else
      redirect_to edit_admin_match_path(@match), alert: @match.errors.full_messages.first
    end
  end

  def set_winner
    if params[:commit] == "Winner #{@match.home_team.short_name}"
      @match.winning_team = @match.home_team
    elsif params[:commit] == "Winner #{@match.visit_team.short_name}"
      @match.winning_team = @match.visit_team
    end
    if @match.save
      @match.update_picks
      redirect_to root_path, notice: "Match winner set to #{@match.winning_team.short_name} updated successfully"
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def match_params
    params
      .require(:match)
      .permit :start_time, :week_id, :visit_team_id, :home_team_id,
              :winning_team_id, :untie, :premium, :visit_team_score,
              :home_team_score, :show_time, :order
  end
end
