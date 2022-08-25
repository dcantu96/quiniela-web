class Admin::RequestsController < Admin::BaseController
  before_action :set_request, only: [:update]
  
  def update
    puts params
    if params[:status] == 'accept'
      @membership = Membership.new group: @request.group, account: @request.account
      if @membership.valid? && @request.destroy && @membership.save
        RequestMailer.request_accepted(@membership).deliver_now
        redirect_to requests_admin_group_path(@membership.group), notice: 'Request accepted'
      else
        redirect_to requests_admin_group_path(@request.group), alert: @request.errors.full_messages
      end
    end
    if params[:status] == 'reject'
      if @request.update denied: true
        RequestMailer.request_denied(@request).deliver_now
        redirect_to requests_admin_group_path(@request.group), notice: 'Request rejected'
      else
        redirect_to requests_admin_group_path(@request.group), alert: @request.errors.full_messages
      end
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def group_params
    params.require(:group).permit :name, :private, :tournament_id
  end
end
