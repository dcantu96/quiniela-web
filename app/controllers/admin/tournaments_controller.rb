class Admin::TournamentsController < Admin::BaseController
  before_action :set_tournament, only: [:update, :show, :edit, :setup, :destroy]

  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
  end

  def show
    @current_week = @tournament.current_week
    @weeks = @tournament.weeks.order(number: :asc)
  end

  def edit; end

  def setup
    TournamentUpdaterJob.perform_later(@tournament.id)
    redirect_to admin_groups_path, notice: 'Generating tournament matches for the first time. This could take 5 minutes.'
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

  def destroy
    if @tournament.destroy
      redirect_to admin_tournaments_path
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
