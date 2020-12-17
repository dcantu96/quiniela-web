class AdminMailer < ActionMailer::Base
  default to: -> { User.with_role(:admin).pluck(:email) },
          from: 'notifications@qnflmty.com'
  layout 'mailer'

  def update_success(week, group)
    @week = week
    @group = group
    mail(subject: "Update Complete | Week #{week.number}")
  end
end
