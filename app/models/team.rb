class Team < ApplicationRecord
  belongs_to :sport
  has_many :visit_matches, class_name: 'Match', foreign_key: :visit_team_id, inverse_of: :visit_team
  has_many :home_matches, class_name: 'Match', foreign_key: :home_team_id, inverse_of: :home_team
  has_many :wins, class_name: 'Match', foreign_key: :winning_team_id, inverse_of: :winning_team
  has_many :picks, class_name: 'Pick', foreign_key: :picked_team_id, inverse_of: :picked_team
  validates :name, uniqueness: true
  validates :short_name, uniqueness: true
end
