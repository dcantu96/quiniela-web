task :update_week => :environment do
  groups = Group.active
  groups.each do |group|
    group.daily_update
  end
end