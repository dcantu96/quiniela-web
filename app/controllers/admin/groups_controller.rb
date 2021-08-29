class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :matches, :requests, :winners, :members,
    :table, :members_forgetting, :autocomplete, :reset_week_points, :update_picks, :fetch_match_results, :update_total_points, :settings]
  before_action :set_week, only: [:reset_week_points, :update_picks, :fetch_match_results, :update_total_points]
  layout 'admin_group', except: [:index, :new]

  def index
    @groups = Group.includes(:tournament)
    if params[:tournament_id]
      @groups = Group.includes(:tournament).where(tournament_id: params[:tournament_id])
    else
      @groups = Group.includes(:tournament)
    end
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def matches
    @weeks = @group.tournament.weeks
    if filtering_params.present?
      @week = @group.tournament.weeks.find_by(number: filtering_params[:week_number])
      @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    else
      @week = @group.tournament.current_week
      @matches = @group.tournament.current_week_matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    end
  end

  def members_forgetting
    @membership_weeks = @group.membership_weeks_forgetting @group.tournament.current_week
    @matches = @group.tournament.current_week_matches
  end

  def table
    @weeks = @group.tournament.weeks
    if filtering_params.present?
      week = @group.tournament.weeks.find_by(number: filtering_params[:week_number])
      @membership_weeks = @group.membership_weeks_of week
      @matches = week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    else
      @membership_weeks = @group.membership_weeks_of @group.tournament.current_week
      @matches = @group.tournament.current_week_matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    end
  end

  def members
    @memberships = @group.memberships.order(position: :asc)
  end

  def winners
    @weeks = @group.tournament.weeks
    @untie_match = @group.tournament.current_week.untie_match
    if filtering_params.present?
      week = @group.tournament.weeks.find_by(number: filtering_params[:week_number])
      @winners = @group.winners.joins(:membership_week).where(membership_weeks: { week: week })
      @possible_winners = @group.membership_weeks.where(week: week).order(points: :desc).limit(10).includes(membership: [:account, :group])
    else
      @winners = @group.winners.joins(:membership_week).where(membership_weeks: { week: @group.tournament.current_week })
      @possible_winners = @group.membership_weeks.where(week: @group.tournament.current_week).order(points: :desc).limit(10).includes(membership: [:account, :group])
    end
  end

  def requests
    @requests = @group.requests
  end

  def settings
  end

  def create
    @group = Group.new group_params
    if @group.save
      redirect_to admin_groups_path
    else
      render :new
    end       
  end

  def update
    if @group.update group_params
      redirect_to admin_groups_path
    else
      render :edit
    end
  end

  def update_total_points
    @group.update_member_positions
    redirect_to matches_admin_group_path(@group), notice: 'Update member positions successfully'
  end

  def reset_week_points
    if @week.reset_points(@group)
      redirect_to matches_admin_group_path(@group), notice: 'Week points and picks reset successfull'
    end
  end

  def fetch_match_results
    if @week.fetch_match_results
      redirect_to matches_admin_group_path(@group), notice: 'Match results fetched successfully'
    end
  end

  def update_picks
    if @week.update_picks
      redirect_to matches_admin_group_path(@group), notice: 'Match results fetched successfully'
    end
  end

  def autocomplete
    @accounts = Account.where(memberships: @group.memberships)
      .ransack(username_cont: params[:q]).result(distinct: true).limit(5)
    
    respond_to do |format|
      format.json {
        render json: { results: render_to_string(partial: "autocomplete", formats: [:html]) }
      }
    end
  end

  private

  def filtering_params
    params.slice(:week_number)
  end

  def set_filter_status
    @filters_empty = filtering_params.empty?
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def set_week
    @week = Week.find(params[:week_id])
  end

  def group_params
    params.require(:group).permit :name, :private, :tournament_id, :finished
  end
end
