class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show]
  before_action :validate_user
  before_action :set_filter_status, only: [:show]

  def show
    filtering_params.present? ? @picks = @membership.picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).filt(filtering_params).joins(:match).order('matches.start_time') :
      @picks = @membership.current_week_picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).joins(:match).order('matches.start_time')
    @group_weeks = @membership.group.group_weeks.includes(:week)
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
