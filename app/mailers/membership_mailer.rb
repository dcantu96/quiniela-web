class MembershipMailer < ActionMailer::Base
  default from: 'notifications@qnflmty.com'
  layout 'mailer'

  def picks_reminder
    @membership = params[:membership]
    mail(to: @membership.account.user.email, subject: "#{@membership.account.username}, you have missing picks!")
  end
end
