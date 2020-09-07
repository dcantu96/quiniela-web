class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:edit, :update, :show, :requests, :picks, :winners]

  def index
    @groups = Group.includes(:tournament)
  end

  def new
    @group = Group.new
  end

  def show
  end

  def edit
  end

  def requests
    @requests = @group.requests
  end

  def picks
    @weeks = @group.group_weeks
  end

  def winners
    @weeks = @group.group_weeks
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
