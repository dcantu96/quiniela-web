class Admin::SportsController < Admin::BaseController
  before_action :set_sport, only: [:update, :show, :edit]

  def index
    @sports = Sport.all
  end

  def new
    @sport = Sport.new
  end

  def show
    @tournaments = @sport.tournaments
  end

  def edit
  end

  def create
    @sport = Sport.new sport_params
    if @sport.save
      redirect_to admin_sports_path
    else
      render :new
    end       
  end

  def update
    if @sport.update sport_params
      redirect_to admin_sports_path
    else
      render :edit
    end
  end

  private

  def set_sport
    @sport = Sport.find(params[:id])
  end

  def sport_params
    params.require(:sport).permit :name
  end
end
