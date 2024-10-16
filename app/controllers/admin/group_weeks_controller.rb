class Admin::GroupWeeksController < Admin::BaseController
  before_action :set_group, only: [:index, :edit]
  before_action :set_group_week, only: [:edit, :update]
  layout 'admin_group'

  def index
    @group_weeks = @group.group_weeks.includes(:week).order('weeks.number ASC')
    @winners = @group.winners
  end

  def edit
    @week_winners_ids = @group_week.group.winners.joins(membership_week: :week).where(membership_weeks: { week: @group_week.week }).pluck(:membership_week_id)
    @untie_match = @group_week.week.untie_match
    @highest_memberships ||= @group_week.group.membership_weeks
      .where(week: @group_week.week)
      .includes(membership: :account)
      .includes(:picks)
      .joins("LEFT JOIN picks AS untie_pick ON untie_pick.match_id = #{@untie_match.id} AND untie_pick.membership_week_id = membership_weeks.id")
      .select("membership_weeks.*, 
              COALESCE(ABS((#{@untie_match.home_team_score} + #{@untie_match.visit_team_score}) - untie_pick.points), 999999) AS untie_difference")
      .order('membership_weeks.points DESC, untie_difference ASC')
      .limit(5)
    @lowest_valid_points_list ||= @group_week.group.membership_weeks.active_members.where(week: @group_week.week).order('points ASC').limit(10).map do |membership_week|
      ["#{membership_week.membership.account.username} - puntos #{membership_week.points} - picks vacios #{membership_week.picks.where(picked_team: nil).count}", membership_week.points]
    end
  end

  def update
    if @group_week.update group_week_params
      week = @group_week.week
      if week.update finished: true
        @membership_weeks = MembershipWeek.where(id: winner_params[:winner_ids])
        @group_week.group.winners
          .joins(membership_week: :week)
          .where(membership_weeks: { week: @group_week.week })
          .destroy_all
        @membership_weeks.each do |membership_week|
          winner = Winner.new membership_week: membership_week
          winner.save if winner.valid?
        end
        TournamentWeekUpdaterJob.perform_later(@group_week.week.id)
        redirect_to admin_group_weeks_path(@group_week.group), notice: 'En unos minutos recibirá un correo confirmando que se actualizaron todos puntos de la semana correctamente.'
      end
    end
  end

  private

  def set_group_week
    @group_week = GroupWeek.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def group_week_params
    params.require(:group_week).permit :lowest_valid_points
  end

  def winner_params
    params.require(:group_week).permit winner_ids: []
  end
end
