class Admin::MembershipsController < Admin::BaseController
  before_action :set_membership, only: [:picks, :settings, :update, :destroy]
  before_action :set_group, only: [:picks, :settings, :update, :destroy]
  before_action :set_week_and_picks, only: [:show, :picks]

  def picks
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end
  
  def settings

  end

  def update
    if @membership.update membership_params
      redirect_to members_admin_group_path(@group), notice: 'Membership updated successfully'
    else
      redirect_to settings_admin_group_membership_path(@group, @membership), alert: @membership.errors.full_messages
    end
  end
  def destroy
    if @membership.destroy
      redirect_to members_admin_group_path(@group), notice: 'Membership deleted successfully'
    else
      redirect_to settings_admin_group_membership_path(@group, @membership), alert: @membership.errors.full_messages
    end
  end

  private

  def set_week_and_picks
    filtering_params.present? ? (
      @picks = @membership.membership_weeks.find_by(week: Week.find_by(number: filtering_params[:week_number])).picks
      @week = @membership.group.tournament.weeks.find_by(number: filtering_params[:week_number])
      ) : (
      @picks = @membership.current_week_picks
      @week = @membership.group.tournament.current_week
    )
    @picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).order('matches.order')
  end

  def filtering_params
    params.slice(:week_number)
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
end
