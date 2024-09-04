class Admin::RequestsController < Admin::BaseController
  before_action :set_request, only: [:update]
  
  def update
    if params[:status] == 'accept'
      AcceptRequestJob.perform_later(params[:id])
      redirect_to requests_admin_group_path(@request.group), notice: 'Request accepted'
    end
    if params[:status] == 'reject'
      RejectRequestJob.perform_later(params[:id])
      redirect_to requests_admin_group_path(@request.group), notice: 'Request rejected'
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
