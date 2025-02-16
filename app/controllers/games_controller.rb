require "net/http"

class GamesController < ApplicationController
  before_action :authenticate_user!
  def index
    @games = Game.includes(:users).where(phase: "lobby")
  end

  def create
    @game = Game.new

    @game.game_type = "Random"
    @game.name = "Random"
    @game.steps = 2
    @game.current_step = 1
    @game.phase = "lobby"
    @game.users << current_user
    @game.creator = current_user.email

    coords = RandomCoordinate.order(Arel.sql("RANDOM()")).limit(@game.steps).pluck("lat", "long")

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
    @game = Game.find_by(id: params[:id])

    if @game.nil?
      redirect_to root_path
    end

    game_player = @game.game_players.find_by(user: current_user)
    if !game_player
      redirect_to root_path
    end

    if @game.phase == "lobby"
      redirect_to lobby_game_path(@game)
    end

    @game.with_lock do
      unless @game.game_state_exists?
        @game.set_game_state!
      end
    end
  end

  def player_ready
    game = Game.find(params[:id])
    game_player = game.game_players.find_by(user: current_user)
    game_player.ready!(params[:ready], params[:answer])
  end

  def add_player
    @game = Game.find(params[:id])
    @game.game_players.find_or_create_by(user: current_user)

    redirect_to lobby_game_path(@game)
  end

  def update_game_phase
    @game = Game.find(params[:id])
    if @game.update(phase: "game")
      head :ok
    else
      redirect_to root_path
    end
  end

  def lobby
    @game = Game.includes(:users).find(params[:id])

    if @game.phase != "lobby"
      redirect_to root_path
    end

    @creator = @game.creator == current_user.email
  end

  private
end
