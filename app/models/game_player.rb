class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def ready!(ready, answer)
    update(ready: ready, current_answer: answer)
    game.next_step! if game.all_players_ready?
  end
end
