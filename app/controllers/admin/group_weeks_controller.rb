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

    # Step 1: Get the highest points for the given week
    highest_points = @group_week.group.membership_weeks
      .where(week: @group_week.week)
      .maximum(:points)

    # Step 2: Fetch memberships with the highest points and calculate untie_difference
    memberships_with_highest_points = @group_week.group.membership_weeks
      .where(week: @group_week.week, points: highest_points)
      .joins("LEFT JOIN picks AS untie_pick ON untie_pick.match_id = #{@untie_match.id} AND untie_pick.membership_week_id = membership_weeks.id")
      .select("membership_weeks.*, 
      COALESCE(ABS((#{@untie_match.home_team_score} + #{@untie_match.visit_team_score}) - untie_pick.points), 999999) AS untie_difference")

    # Step 3: Find the minimum untie_difference among those with the highest points
    lowest_untie_difference = memberships_with_highest_points.minimum("COALESCE(ABS((#{@untie_match.home_team_score} + #{@untie_match.visit_team_score}) - untie_pick.points), 999999)")

    # Step 4: Fetch only the memberships with the highest points and the lowest untie_difference
    @highest_memberships ||= memberships_with_highest_points
      .where("COALESCE(ABS((#{@untie_match.home_team_score} + #{@untie_match.visit_team_score}) - untie_pick.points), 999999) = ?", lowest_untie_difference)
      .includes(membership: :account) # Eager load membership and account to prevent N+1 in the view
      .includes(:picks)               # Eager load picks to prevent N+1 when fetching untie match picks


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
