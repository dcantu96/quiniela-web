class PublicController < ActionController::Base
  layout 'login'
  def rules
    render layout: 'application' if current_user
  end
end
