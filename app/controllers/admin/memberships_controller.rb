class Admin::MembershipsController < Admin::BaseController
  before_action :set_membership, only: [:show, :table, :picks, :members, :winners, :requests]

  def show
    filtering_params.present? ? @picks = @membership.membership_weeks.find_by(week: Week.find_by(number: filtering_params[:week_number])).picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time') :
      @picks = @membership.current_week_picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time')
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def table
    @membership_weeks = @membership.group.membership_weeks.where(week: @membership.group.tournament.current_week).order(points: :desc).limit(40).includes(picks: [:picked_team, match: [:winning_team]])
    @matches = @membership.group.tournament.current_week.matches.includes(:home_team, :visit_team, :winning_team).order('matches.start_time')
  end

  def picks
    filtering_params.present? ? @picks = @membership.membership_weeks.find_by(week: Week.find_by(number: filtering_params[:week_number])).picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time') :
      @picks = @membership.current_week_picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time')
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def members
    @memberships = @membership.group.memberships
  end

  def winners
    @winners = @membership.group.memberships
  end

  def requests
    @requests = @membership.group.requests
  end

  private

  def filtering_params
    params.slice(:week_number)
  end

  def set_filter_status
    @filters_empty = filtering_params.empty?
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
