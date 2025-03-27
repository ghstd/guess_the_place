class GamePlayer < ApplicationRecord
  serialize :subscribtions, coder: JSON

  belongs_to :game
  belongs_to :user

  after_create_commit do
    next if game.game_players.count == 1

    broadcast_update_players_quantity
  end

  after_update_commit do
    if saved_change_to_attribute?(:ready)
      broadcast_render_to "game_#{game.id}", partial: "games/turbo_stream/update_show_user_info", locals: { player: self }
      GameProgress.call(game).next_step_if_all_players_ready if ready
    end

    if saved_change_to_attribute?(:connection)
      broadcast_render_to "game_#{game.id}", partial: "games/turbo_stream/update_show_user_info", locals: { player: self }

      if connection == "offline"
        game.with_lock do
          if game.game_players.where(connection: "offline").count == game.game_players.count
            if game.phase == "lobby"
              game.update(phase: "delete")
            else
              DeleteEmptyGameJob.set(wait: 5.seconds).perform_later(game.id)
            end
          end
        end
      end
    end
  end


  def ready!(ready, answer)
    update(ready: ready, current_answer: answer)
  end

  def broadcast_update_players_quantity
    broadcast_render_to "lobby_#{game.id}", partial: "games/turbo_stream/update_lobby_members", locals: { game: game }
    broadcast_render_to "games", partial: "games/turbo_stream/update_index_players_quantity", locals: { game: game }
  end
end
