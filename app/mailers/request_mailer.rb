class RequestMailer < ActionMailer::Base
  default from: 'notifications@qnflmty.com'
  layout 'mailer'

  def request_denied(request)
    @request = request
    @group = request.group
    @account = request.account
    @user = @account.user
    mail(to: @user.email, subject: "Solicitud de #{@account.username} rechazada")
  end

  def request_accepted(membership)
    @membership = membership
    @group = membership.group
    @account = membership.account
    @user = @account.user
    mail(to: @user.email, subject: "Solicitud de #{@account.username} aprobada")
  end
end
