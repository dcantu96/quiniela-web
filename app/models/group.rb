class Group < ApplicationRecord
  belongs_to :tournament
  has_many :requests
  has_many :memberships
  has_many :membership_weeks
  has_many :accounts, through: :memberships
  validates_uniqueness_of :name
  validates_presence_of :name
  after_create :generate_group_weeks

  # def team_size
  #   Rails.cache.fetch(:team_size, expires_in: 4.hour) do
  #     analytics_client = AnalyticsClient.query!(self)
  #     analytics_client.team_size
  #   end
  # end

  private

  def generate_group_weeks
    tournament.weeks.each do |week|
      group_weeks.create week: week
    end
  end
end
