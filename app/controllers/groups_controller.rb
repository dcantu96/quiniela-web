class GroupsController < ApplicationController
  before_action :set_group, only: [:show]

  def show
  end

  def winners
    
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
