class Admin::WeeksController < Admin::BaseController
  before_action :set_week, only: [:update, :show, :edit, :generate_week_matches, :update_matches]
  before_action :set_group, only: [:generate_week_matches]

  def index
    @weeks = Week.all
  end

  def new
    @week = Week.new
  end

  def show
    @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
  end

  def generate_week_matches
    if @week.generate_matches
      redirect_to matches_admin_group_path(@group, week_id: @week.id), notice: 'Matches generated successfully'
    end
  end

  def update_matches
    if @week.update_matches
      redirect_to admin_week_path(@week), notice: 'Attempted to update matches, please check manually'
    end
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
      redirect_to admin_root_path, notice: 'Week updated successfully'
    else
      render :edit
    end
  end

  private

  def set_week
    @week = Week.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def week_params
    params.require(:week).permit :number, :tournament_id, :finished
  end
end
