class NotPaidController < ActionController::Base
  layout 'application'
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :validate_user_payments, if: :current_user

  def index; end

  private

  def validate_user_payments
    return if current_user.memberships.active.not_paid.present? && Time.now > Time.parse('2025-10-16 01:00:00 -0600')
    redirect_to root_path
  end
end
