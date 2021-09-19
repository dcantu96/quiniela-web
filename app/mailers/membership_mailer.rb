class MembershipMailer < ActionMailer::Base
  default from: 'notifications@qnflmty.com'
  layout 'mailer'

  def picks_reminder
    @membership_week = params[:membership_week]
    @membership = @membership_week.membership
    @user = @membership.account.user
    mail(to: @user.email, subject: "#{@membership.account.username}, you have missing picks!")
  end
end
