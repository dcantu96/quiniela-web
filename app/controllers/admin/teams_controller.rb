class Admin::TeamsController < Admin::BaseController
  before_action :set_team, only: [:update, :edit]
  before_action :set_sport, only: [:new]

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new team_params
    if @team.save
      redirect_to admin_sport_path(@team.sport)
    else
      @sport = Sport.find(team_params[:sport_id])
      render :new
    end       
  end

  def update
    if @team.update team_params
      redirect_to admin_sport_path(@team.sport)
    else
      render :edit
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def set_sport
    @sport = Sport.find(params[:sport_id])
  end

  def team_params
    params.require(:team).permit :name, :short_name, :sport_id
  end
end
