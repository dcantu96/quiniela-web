class AdminMailer < ActionMailer::Base
  default to: -> { User.with_role(:admin).pluck(:email) },
          from: 'notifications@qnflmty.com'
  layout 'mailer'

  def update_week_success(week)
    @week = week
    mail(subject: "Actualización completa | Semana #{week.number}")
  end

  def update_auto_week_success(week)
    @week = week
    mail(subject: "Actualización completa | Semana #{week.number}")
  end

  def update_tournament_success(tournament)
    @tournament = tournament
    mail(subject: "Actualización de torneo exitosa!")
  end
end
