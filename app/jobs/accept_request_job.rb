class AcceptRequestJob < ApplicationJob 
  queue_as :default

  def perform(request_id)
    request = Request.find(params[:id])
    membership = Membership.new group: request.group, account: request.account
    if membership.valid? && request.destroy && membership.save
      RequestMailer.request_accepted(membership).deliver_later
    end
  end
end
