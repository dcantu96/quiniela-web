class RejectRequestJob < ApplicationJob 
  queue_as :default

  def perform(request_id)
    request = Request.find(params[:id])
    if request.update denied: true
      RequestMailer.request_denied(request).deliver_later
    end
  end
end
