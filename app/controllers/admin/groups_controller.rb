class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :requests, :winners, :members, :table]

  def index
    @groups = Group.includes(:tournament)
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def table
    @membership_weeks = @group.membership_weeks.where(week: @group.tournament.current_week).order(points: :desc).limit(40).includes(picks: [:picked_team, match: [:winning_team]])
    @matches = @group.tournament.current_week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
  end

  def members
    @memberships = @group.memberships
  end

  def winners
    @winners = @group.memberships
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

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit :name, :private, :tournament_id
  end
end
