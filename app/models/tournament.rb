class Tournament < ApplicationRecord
  belongs_to :sport
  has_many :weeks
  has_many :matches, through: :weeks
  has_many :groups

  def current_week
    @current_week ||= weeks.where(finished: false).order(number: :asc).limit(1).first
  end
end
