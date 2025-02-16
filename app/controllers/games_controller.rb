require "net/http"

class GamesController < ApplicationController
  before_action :authenticate_user!
  def index
    @games = Game.includes(:users).where(phase: "lobby")
  end

  def new
  end

  def create
    steps = 4
    current_step = 1
    @game = Game.new
    @game.steps = steps
    @game.current_step = current_step
    @game.users << current_user
    @game.creator = current_user.email
    coords = RandomCoordinate.order(Arel.sql("RANDOM()")).limit(steps).pluck("lat", "long")
    if @game.save
      coords.each do |coord|
        @game.game_coordinates.create(lat: coord[0], long: coord[1])
      end
      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def show
    @game = Game.find(params[:id])
    @coords = @game.game_coordinates.pluck("lat", "long")[@game.current_step - 1]
    street = @game.get_street_by_coords(@coords)
    street = @game.normalize_street_name(street)
    @game.update(answer: street)
    @set_of_streets = Street.where.not(name: street).order(Arel.sql("RANDOM()")).limit(3).pluck(:name)
    @set_of_streets.map! { |street| @game.normalize_street_name(street) }
    @set_of_streets.push(street).shuffle!
  end

  def get_geodata
    @game = Game.find(params[:id])
    coords = @game.game_coordinates.pluck("lat", "long")[@game.current_step - 1]

    render json: coords
  end

  def player_ready
    game = Game.find(params[:id])
    game_player = game.game_players.find_by(user: current_user)
    game_player.ready!(params[:ready], params[:answer])


    # Turbo::StreamsChannel.broadcast_render_to(
    #   "game_#{@game.id}",
    #   partial: "games/test"
    # )
  end

  def edit
  end

  def update_players_quantity
    @game = Game.find(params[:id])
    @game.game_players.find_or_create_by(user: current_user)

    redirect_to lobby_game_path(@game)
  end

  def update_phase
    @game = Game.find(params[:id])
    if @game.update(phase: "game")
      head :ok
    else
      redirect_to root_path
    end
  end

  def destroy
  end

  def lobby
    @game = Game.includes(:users).find(params[:id])
    @creator = @game.creator == current_user.email
  end

  private
end
