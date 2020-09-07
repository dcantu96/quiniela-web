class Pick < ApplicationRecord
  belongs_to :membership
  belongs_to :match
  belongs_to :group_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
  # validate :pick_not_passed_time


  # def pick_not_passed_time
  #   if ((Time.now > match.start_time-30.minutes || Time.now > group_week.week.start_time && !match.untie) || (match.untie && Time.now > match.start_time-30.minutes)) && !self.new_record?
  #     errors.add :date, 'Match or week has started.'
  #   end
  # end
end
