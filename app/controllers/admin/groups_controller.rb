class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :matches, :requests, :winners, :members, :danger_settings, :destroy,
    :table, :members_forgetting, :autocomplete, :reset_week_points, :update_picks, :fetch_match_results, 
    :update_total_points, :settings, :notify_missing_picks, :users, :inactive_accounts, :update_memberships]
  before_action :set_week, only: [:reset_week_points, :update_picks, :fetch_match_results, :update_total_points]
  layout 'admin_group', except: [:index, :new]

  def index
    @groups = Group.includes(:tournament)
    if params[:tournament_id]
      @groups = Group.includes(:tournament).where(tournament_id: params[:tournament_id])
      @tournament = Tournament.find_by(id: params[:tournament_id])
    else
      @groups = Group.includes(:tournament)
    end
    render layout: 'admin'
  end

  def new
    @group = Group.new
    render layout: 'admin'
  end

  def edit
  end

  def danger_settings
  end

  def matches
    @weeks = @group.tournament.weeks.order(number: :asc)
    if filtering_params.present?
      @week = @group.tournament.weeks.find_by(id: filtering_params[:week_id])
      @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    else
      @week = @group.tournament.current_week
      @matches = @group.tournament.current_week_matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
    end
  end

  def members_forgetting
    @records = @group.membership_weeks_forgetting @group.tournament.current_week
    @matches = @group.tournament.current_week_matches
  end

  def table
    tournament = @group.tournament
    @weeks = tournament.weeks.order(number: :asc)
    week = filtering_params[:week_id] ? tournament.weeks.find_by(id: filtering_params[:week_id]) : tournament.current_week
    @pagy, @records = pagy(@group.membership_weeks_of(week), items: 20)
    @matches = week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
  end

  def members
    # Here we will be able to see suspended people
    @memberships = @group.memberships.order(suspended: :asc, position: :asc)
  end

  def notify_missing_picks
    tournament = @group.tournament
    week = filtering_params[:week_id] ? tournament.weeks.find_by(id: filtering_params[:week_id]) : tournament.current_week
    if @group.notify_missing_picks(week)
      redirect_back fallback_location: matches_admin_group_path(@group), notice: 'Email reminders sent successfully'
    end
  end

  def winners
    @weeks = @group.tournament.weeks
    @untie_match = @group.tournament.current_week.untie_match
    if filtering_params.present?
      week = @group.tournament.weeks.find_by(id: filtering_params[:week_id])
      @winners = @group.winners.joins(:membership_week).where(membership_weeks: { week: week })
      @possible_winners = @group.membership_weeks.where(week: week).order(points: :desc).limit(10).includes(membership: [:account, :group])
    else
      @winners = @group.winners.joins(:membership_week).where(membership_weeks: { week: @group.tournament.current_week })
      @possible_winners = @group.membership_weeks.where(week: @group.tournament.current_week).order(points: :desc).limit(10).includes(membership: [:account, :group])
    end
  end

  def requests
    @requests = @group.requests.pending
    @veterans = Account.includes(memberships: [:group]).where.not(id: @group.requests.pluck(:account_id) + @group.accounts.ids).where(memberships: { groups: { finished: true } })
  end

  def settings
    @current_week = @group.tournament.current_week
    @next_match = @group.tournament.matches.order(start_time: :asc).first
  end

  def create
    @group = Group.new group_params
    if @group.save
      redirect_to admin_groups_path, notice: 'Gropo creado exitosamente' 
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

  def users
    @users = @group.memberships.group_by{ |m| m.account.user }  
  end

  def inactive_accounts
    active_accounts = Account.includes(:memberships).where(memberships: { group_id: @group.id })
    @inactive_accounts = Account.where.not(id: active_accounts)
  end

  def destroy
    if @group.destroy
      redirect_to admin_groups_path, notice: 'Group deleted successfully'
    else
      redirect_to danger_settings_admin_group_path(@group), alert: @group.errors.full_messages
    end
  end

  def update_total_points
    if @group.update_member_positions
      redirect_back fallback_location: matches_admin_group_path(@group), notice: 'Update member positions successfully'
    else
      redirect_back fallback_location: matches_admin_group_path(@group), alert: 'Error updating member positions'
    end
  end

  def reset_week_points
    if @week.reset_points(@group)
      redirect_back fallback_location: matches_admin_group_path(@group), notice: 'Week points and picks reset successfull'
    else
      redirect_back fallback_location: matches_admin_group_path(@group), alert: 'Error resetting points'
    end
  end

  def fetch_match_results
    if @week.fetch_match_results
      redirect_back fallback_location: matches_admin_group_path(@group), notice: 'Match results fetched successfully'
    else
      redirect_back fallback_location: matches_admin_group_path(@group), alert: 'Error fetching match results'
    end
  end

  def update_picks
    if @week.update_picks
      redirect_back fallback_location: matches_admin_group_path(@group), notice: 'Picks updated succesfully'
    else
      redirect_back fallback_location: matches_admin_group_path(@group), alert: 'Error updating picks'
    end
  end

  def update_memberships
    MembershipUpdaterJob.perform_later(@group.id)
    redirect_to settings_admin_group_path(@group), notice: 'Updating Memberships. This could take 2 minutes.'
  end

  def autocomplete
    @q = @group.memberships.ransack(account_username_or_account_user_full_name_or_account_user_email_cont: params[:q])
    @memberships = @q.result(distinct: true).limit(5)
    
    respond_to do |format|
      format.json {
        render json: { results: render_to_string(partial: "autocomplete", formats: [:html]) }
      }
    end
  end

  private

  def filtering_params
    params.slice(:week_id)
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
