class Admin::TournamentsController < Admin::BaseController
  before_action :set_tournament, only: [:update, :show, :edit, :generate_week_matches, :update_week_matches]

  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
  end

  def show
    @current_week = @tournament.current_week
    @weeks = @tournament.weeks
  end

  def edit
  end

  def generate_week_matches
    @tournament.generate_week_matches
    redirect_to admin_groups_path
  end

  def update_week_matches
    @tournament.generate_week_matches
    redirect_to admin_groups_path
  end

  def create
    @tournament = Tournament.new tournament_params
    if @tournament.save
      redirect_to admin_tournaments_path
    else
      render :new
    end       
  end

  def update
    if @tournament.update tournament_params
      redirect_to admin_tournaments_path
    else
      render :edit
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit :name, :sport_id, :year
  end
end
