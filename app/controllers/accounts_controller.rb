class AccountsController < ApplicationController
  before_action :set_account, only: [:update, :show, :edit]

  def index
    @active_memberships = current_user.memberships.active
    @requests = current_user.requests.pending
    @accounts = current_user.accounts
    @denied_requests = current_user.requests.denied
  end

  def new
    @account = Account.new
    @account.requests.build
  end

  def show
    @memberships = @account.memberships
  end

  def edit
  end

  def create
    @account = Account.new account_params
    if @account.save
      redirect_to root_path, notice: 'Account created successfully'
    else
      redirect_to new_account_path, alert: @account.errors.full_messages.first
    end       
  end

  def update
    if @account.update account_params
      redirect_to root_path, notice: 'Account updated successfully'
    else
      redirect_to edit_account_path(@account), alert: @account.errors.full_messages.first
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit :username, :user_id,
      requests_attributes: [:group_id]
  end
end
