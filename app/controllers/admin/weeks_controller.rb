class Admin::WeeksController < Admin::BaseController
  before_action :set_week, only: [:update, :show, :edit, :generate]

  def index
    @weeks = Week.all
  end

  def new
    @week = Week.new
  end

  def show
    @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(start_time: :asc)
  end

  def generate
    @week_matches = @week.fetch_week_matches
  end

  def edit
  end

  def create
    @week = Week.new week_params
    if @week.save
      redirect_to admin_tournament_path(@week.tournament)
    else
      render :new
    end       
  end

  def update
    if @week.update week_params
      redirect_to admin_weeks_path
    else
      render :edit
    end
  end

  private

  def set_week
    @week = Week.find(params[:id])
  end

  def week_params
    params.require(:week).permit :number, :tournament_id
  end
end
