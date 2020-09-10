class MembershipWeek < ApplicationRecord
  belongs_to :membership
  belongs_to :week
  belongs_to :group
  has_many :picks, dependent: :destroy
  after_create :generate_picks
  validates :membership, uniqueness: { scope: :week }

  private

  def generate_picks
    week.matches.each do |match|
      picks.create match: match
    end
  end
end
