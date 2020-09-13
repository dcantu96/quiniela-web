class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :table, :picks, :members, :winners]
  before_action :validate_user
  before_action :set_filter_status, only: [:show]
  layout 'membership'

  def show
    filtering_params.present? ? @picks = @membership.membership_weeks.find_by(week: Week.find_by(number: filtering_params[:week_number])).picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time') :
      @picks = @membership.current_week_picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time')
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def table
    @pagy, @membership_weeks = pagy @membership.group.membership_weeks.where(week: @membership.group.tournament.current_week).order(points: :desc).includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
    @matches = @membership.group.tournament.current_week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)

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

  def picks
    filtering_params.present? ? @picks = @membership.membership_weeks.find_by(week: Week.find_by(number: filtering_params[:week_number])).picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time') : (
      @picks = @membership.current_week_picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time')
      @current_week = @membership.group.tournament.current_week
    )
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def members
    @memberships = @membership.group.memberships
  end

  def winners
    @winners = @membership.group.memberships
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

  def validate_user
    if !current_user.admin? && @membership.account.user != current_user
      redirect_to root_path, alert: 'Access restricted'
    end
  end
end
