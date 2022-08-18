class MembershipWeek < ApplicationRecord
  belongs_to :membership
  belongs_to :week
  belongs_to :group
  has_many :picks, dependent: :destroy
  has_many :winners, dependent: :destroy
  after_create :generate_picks
  validates :membership, uniqueness: { scope: :week }
  scope :current, -> (current_week) { where(week: current_week).limit(1) }

  def untie_pick(untie_match)
    picks.find_by match: untie_match
  end

  private

  def generate_picks
    week.matches.each do |match|
      picks.create match: match
    end
  end
end
