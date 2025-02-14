class GamesController < ApplicationController
  def index
    @games = Game.where(phase: "lobby")
  end

  def new
  end

  def create
    @game = Game.new
    @game.members = [ request.remote_ip ]
    @game.creator = request.remote_ip
    @game.coords = [
      [ 48.462173, 35.032184 ],
      [ 48.461923, 35.058812 ],
      [ 48.448249, 35.055316 ],
      [ 48.447284, 35.028574 ]
    ]
    if @game.save
      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(members: @game.members << request.remote_ip)

      # Turbo::StreamsChannel.broadcast_replace_to(
      #   "lobby_#{@game.id}",
      #   target: "lobby_members",
      #   partial: "games/update",
      #   locals: { game: @game }
      # )

      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def update_game_phase
    @game = Game.find(params[:id])
    if @game.update(phase: rand().to_s)
      head :ok
    else
      redirect_to root_path
    end
  end

  def destroy
  end

  def lobby
    @game = Game.find(params[:id])
    @creator = @game.creator == request.remote_ip
  end
end
