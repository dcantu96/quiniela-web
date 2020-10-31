class UserMailer < ActionMailer::Base
  default from: 'notifications@qnflmty.com'
  layout 'mailer'

  def new_update(update)
    @user = params[:user]
    @update = update
    mail(to: @user.email, subject: "UPDATE | #{update.title}")
  end
end
