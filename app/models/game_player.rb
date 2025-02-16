class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :user

  after_commit on: :create do
    next if game.game_players.count == 1

    broadcast_render_to "lobby_#{game.id}", partial: "games/turbo_stream/update_lobby_members", locals: { game: game }
    broadcast_render_to "games", partial: "games/turbo_stream/update_index_players_quantity", locals: { game: game }
  end

  def ready!(ready, answer)
    update(ready: ready, current_answer: answer)
    game.next_step! if game.all_players_ready?
  end
end
