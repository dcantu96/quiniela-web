class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :matches, :requests, :winners, :members, :table]
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

  def table
    @pagy, @membership_weeks = pagy @group.membership_weeks.where(week: @group.tournament.current_week).order(points: :desc).includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
    @matches = @group.tournament.current_week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "members",
                                    formats: [:html]),
          pagination: view_context.pagy_nav(@pagy)
        }
      }
    end
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
