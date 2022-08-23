class Admin::MembershipsController < Admin::BaseController
  before_action :set_membership, only: [:picks, :settings, :update, :destroy]
  before_action :set_group, only: [:picks, :settings, :update]
  before_action :set_week_and_picks, only: [:show, :picks]

  def picks
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end
  
  def settings
    @other_memerships = @membership.account.user.memberships
      .where(
        'group_id = :gid AND memberships.id != :mid',
        gid: @membership.group.id,
        mid: @membership.id)

  end

  def update
    if @membership.update membership_params
      redirect_to members_admin_group_path(@group), notice: 'Membership updated successfully'
    else
      redirect_to settings_admin_group_membership_path(@group, @membership), alert: @membership.errors.full_messages
    end
  end

  def destroy
    group = @membership.group
    if @membership.destroy
      redirect_to members_admin_group_path(group), notice: 'Membership deleted successfully'
    else
      redirect_to settings_admin_group_membership_path(group, @membership), alert: @membership.errors.full_messages
    end
  end

  def create
    @membership = Membership.new new_membership_params
    if @membership.save
      redirect_to admin_request_path(@membership.group), notice: 'Membership created successfully'
    else
      redirect_to admin_request_path(@membership.group), alert: @membership.errors.full_messages.first
    end       
  end

  private

  def set_week_and_picks
    filtering_params.present? ? (
      @week = @membership.group.tournament.weeks.find_by(id: filtering_params[:week_id])
      @picks = @membership.membership_weeks.find_by(week: @week).picks
      ) : (
      @week = @membership.group.tournament.current_week
      @picks = @membership.current_week_picks
    )
    @picks = @picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).order('matches.order')
  end

  def filtering_params
    params.slice(:week_id)
  end

  def set_filter_status
    @filters_empty = filtering_params.empty?
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def membership_params
    params.require(:membership).permit :suspended, :paid, :notes
  end

  def new_membership_params
    params.require(:membership).permit :account_id, :group_id
  end
end
