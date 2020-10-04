class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :matches, :requests, :winners, :members, :table, :members_forgetting, :autocomplete]
  layout 'admin_group', except: [:index]

  def index
    @groups = Group.includes(:tournament)
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def matches
    @week = @group.tournament.current_week
    @matches = @week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
  end

  def members_forgetting
    @membership_weeks = @group.membership_weeks_forgetting @group.tournament.current_week
    @matches = @group.tournament.current_week_matches
  end

  def table
    @membership_weeks = @group.membership_weeks_of @group.tournament.current_week
    @matches = @group.tournament.current_week_matches
  end

  def members
    @memberships = @group.memberships.order(position: :asc)
  end

  def winners
    @untie_match = @group.tournament.current_week.matches.where(untie: true).first
    @winners = @group.winners.joins(:membership_week).where(membership_weeks: { week: @group.tournament.current_week })
    if @group.tournament.current_week.untie_match.started?
      @possible_winners = @group.membership_weeks.where(week: @group.tournament.current_week).order(points: :desc).limit(10).includes(membership: [:account, :group])
    end
  end

  def requests
    @requests = @group.requests
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

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit :name, :private, :tournament_id
  end
end
