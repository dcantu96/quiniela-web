class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :table, :picks, :members, :winners, :autocomplete, :public_picks]
  before_action :validate_user, except: [:public_picks]
  before_action :set_filter_status, only: [:show]
  before_action :set_week_and_picks, only: [:show, :picks, :public_picks]
  layout 'membership'

  def show
    @membership_weeks = @membership.membership_weeks
  end

  def table
    tournament = @membership.group.tournament
    @weeks = tournament.weeks
    week = filtering_params[:week_id] ? tournament.weeks.find_by(id: filtering_params[:week_id]) : tournament.current_week
    @pagy, @records = pagy(@membership.group.membership_weeks_of(week), items: 20)
    @matches = week.matches.includes(:home_team, :visit_team, :winning_team).order(order: :asc)
  end

  def picks
    @untie_pick = @picks.nil? ? nil : @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
    @membership_week = @membership.membership_weeks.find_by(week: @week)
    @points = @membership_week.present? ? @membership_week.points : nil
  end

  def public_picks
    @picks = @picks.viewable
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def members
    @memberships = @membership.group.memberships.where(suspended: false).order(position: :asc)
  end

  def winners
    @winners = @membership.group.winners.joins(membership_week: [:week]).includes(membership_week: [:week]).order('"membership_weeks"."week_id" ASC')
  end

  def autocomplete
    @q = @membership.group.memberships.ransack(account_username_or_account_user_full_name_or_account_user_email_cont: params[:q])
    @memberships = @q.result(distinct: true).limit(5)
    
    respond_to do |format|
      format.json {
        render json: { results: render_to_string(partial: "autocomplete", formats: [:html]) }
      }
    end
  end

  private

  def set_week_and_picks
    filtering_params.present? ? (
      @week = @membership.group.tournament.weeks.find_by(id: filtering_params[:week_id])
      @picks = @membership.picks_of(@week)
      ) : (
      @week = @membership.group.tournament.current_week
      @picks = @membership.current_week_picks
    )
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

  def validate_user
    if !current_user.admin? && @membership.account.user != current_user
      redirect_to root_path, alert: 'Access restricted'
    end
  end
end
