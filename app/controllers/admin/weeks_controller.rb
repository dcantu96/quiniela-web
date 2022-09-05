class Admin::WeeksController < Admin::BaseController
  before_action :set_week, only: [:update, :show, :edit, :update_matches, :update_match_results, :delete_matches, :toggle_finished]

  def index
    @weeks = Week.all
  end

  def new
    @week = Week.new
  end

  def show
    @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    @next_week = @week.tournament.weeks.find_by(number: @week.number + 1)
    @prev_week = @week.tournament.weeks.find_by(number: @week.number - 1)
  end

  def update_match_results
    WeekMatchResultsJob.perform_later(@week.id)
    redirect_to admin_week_path(@week), notice: 'Updating week match results. This could take 2 minutes.'
  end

  def update_matches
    WeekMatchesJob.perform_later(@week.id)
    redirect_to admin_week_path(@week), notice: 'Updating week matches. This could take 2 minutes.'
  end

  def delete_matches
    if @week.matches.destroy_all
      redirect_to admin_week_path(@week), notice: 'Matches deleted successfully'
    end
  end

  def toggle_finished
    @week.update finished: !@week.finished
    redirect_to admin_tournament_path(@week.tournament), notice: 'Week set to finished.'
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
      redirect_to root_path, notice: 'Week updated successfully'
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
