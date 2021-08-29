class Api::V1::TournamentsController < ApplicationController
  def index
    tournaments = Tournament.all
    render json: TournamentSerializer.new(tournaments, options).serialized_json
  end

  def show
    tournament = Tournament.find_by id: params[:id]
    render json: TournamentSerializer.new(tournament, options).serialized_json
  end

  def create
    tournament = Tournament.new tournament_params
    if tournament.save
      render json: TournamentSerializer.new(tournament).serialized_json
    else
      render json: { error: tournament.errors.messages}, status: 422
    end       
  end

  def update
    tournament = Tournament.find_by id: params[:id]
    if tournament.update tournament_params
      render json: TournamentSerializer.new(tournament, options).serialized_json
    else
      render json: { error: tournament.errors.messages}, status: 422
    end       
  end

  def destroy
    tournament = Tournament.find_by id: params[:id]
    if tournament.destroy
      head :no_content
    else
      render json: { error: tournament.errors.messages}, status: 422
    end       
  end

  private

  def tournament_params
    params.require(:tournament).permit :name, :sport_id, :year
  end

  # def options
  #   @option ||= { includes: %i[weeks matches groups] }
  # end
end