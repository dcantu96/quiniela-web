class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :table, :picks, :members, :winners]
  before_action :validate_user
  before_action :set_filter_status, only: [:show]
  before_action :set_week_and_picks, only: [:show, :picks]
  layout 'membership'

  def show
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def table
    @membership_weeks = @membership.group.membership_weeks_of @membership.group.tournament.current_week
    @matches = @membership.group.tournament.current_week_matches

    # respond_to do |format|
    #   format.html
    #   format.json {
    #     render json: { 
    #       entries: render_to_string(partial: "members",
    #                                 formats: [:html]),
    #       pagination: view_context.pagy_nav(@pagy)
    #     }
    #   }
    # end
  end

  def picks
    @untie_pick = @picks.joins(:match).where(matches: { untie: true }).first
    @weeks = @membership.group.tournament.weeks
  end

  def members
    @memberships = @membership.group.memberships.order(position: :asc)
  end

  def winners
    @winners = @membership.group.winners.includes(membership_week: [:week])
  end

  private

  def set_week_and_picks
    filtering_params.present? ? (
      @week = @membership.group.tournament.weeks.find_by(number: filtering_params[:week_number])
      @picks = @membership.membership_weeks.find_by(week: @week).picks
      ) : (
      @week = @membership.group.tournament.current_week
      @picks = @membership.current_week_picks
    )
    @picks = @picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).order('matches.order')
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

  def validate_user
    if !current_user.admin? && @membership.account.user != current_user
      redirect_to root_path, alert: 'Access restricted'
    end
  end
end
