class RequestsController < ApplicationController
  def create
    @request = Request.new request_params
    if @request.save
      redirect_to root_path, notice: 'Request created successfully'
    else
      redirect_to root_path, alert: @request.errors.full_messages.first
    end 
  end

  private

  def request_params
    params.require(:request).permit :group_id, :account_id
  end
end
