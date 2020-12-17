task :update_week => :environment do
  group = Group.first
  week = group.tournament.current_week
  week.fetch_match_results
  week.update_picks
  group.update_member_positions
  AdminMailer.update_success(week, group).deliver_now
end