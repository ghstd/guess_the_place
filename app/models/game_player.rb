class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def ready!
    update(ready: true)
    game.next_step! if game.all_players_ready?
  end
end
