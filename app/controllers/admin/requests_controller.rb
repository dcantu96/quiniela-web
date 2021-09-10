class Admin::RequestsController < Admin::BaseController
  before_action :set_request, only: [:update]
  
  def update
    if params[:commit] == 'Accept'
      @membership = Membership.new group: @request.group, account: @request.account
      if @membership.valid?
        @request.destroy && @membership.save
        redirect_to requests_admin_group_path(@membership.group)
      else
        puts 'error'
      end
    end
    if params[:commit] == 'Reject'
      group = @request.group
      @request.destroy
      redirect_to requests_admin_group_path(group)
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
