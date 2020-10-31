class Admin::UpdatesController < Admin::BaseController
  before_action :set_update, only: [:update, :show, :edit]

  def index
    @updates = Update.all
  end

  def new
    @update = Update.new
  end

  def show
    @tournaments = @update.tournaments
  end

  def edit
  end

  def create
    @update = Update.new update_params
    if @update.save
      redirect_to admin_updates_path
    else
      render :new
    end       
  end

  def update
    if @update.update update_params
      redirect_to admin_updates_path
    else
      render :edit
    end
  end

  private

  def set_update
    @update = Update.find(params[:id])
  end

  def update_params
    params.require(:update).permit :title, :content
  end
end
