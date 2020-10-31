class Update < ApplicationRecord
  has_rich_text :content

  after_create :notify_users

  private

  def notify_users
    User.find_each do |user|
      UserMailer.with(user: user).new_update(self).deliver_later
    end
  end
end
