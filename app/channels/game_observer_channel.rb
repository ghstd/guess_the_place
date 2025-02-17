class GameObserverChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_observer_#{params[:game_id]}"

    player = GamePlayer.find_by(id: params[:player_id])
    player.update(connection: "online")
  end

  def unsubscribed
    game = Game.find_by(id: params[:game_id])

    if game
      player = GamePlayer.find_by(id: params[:player_id])
      player.update(connection: "offline")

      DeleteEmptyGameJob.set(wait: 5.seconds).perform_later(params[:game_id])
    end
  end
end
