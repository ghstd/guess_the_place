class GameObserverChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_observer_#{params[:game_id]}"

    player = GamePlayer.find_by(id: params[:player_id])
    player.update(connection: "online")
  end

  def unsubscribed
    game = Game.find_by(id: params[:game_id])
    return unless game

    player = GamePlayer.find_by(id: params[:player_id])
    player.update(connection: "offline") if player

    game.with_lock do
      online_players_count = game.game_players.where(connection: "online").count
      all_players_count = game.game_players.count

      if online_players_count.zero?
        if all_players_count == 1
          DeleteEmptyGameJob.set(wait: 5.seconds).perform_later(game.id)
          return
        end

        if game.phase == "lobby"
          game.update(phase: "delete")
        else
          DeleteEmptyGameJob.set(wait: 5.seconds).perform_later(game.id)
        end
      end
    end
  end
end
