class AccountsController < ApplicationController
  before_action :set_account, only: [:update, :show, :edit]

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
      redirect_to root_path
    else
      render :new
    end       
  end

  def update
    if @account.update account_params
      redirect_to root_path
    else
      render :edit
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
