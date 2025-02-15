class Game < ApplicationRecord
  serialize :coords, coder: JSON
  serialize :members, coder: JSON

  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :game_coordinates, dependent: :destroy

  after_update_commit do
    if saved_change_to_attribute?(:members)
      broadcast_replace_to "lobby_#{id}", target: "lobby_members_#{id}", partial: "games/lobby_members"
    end

    if saved_change_to_attribute?(:members)
      broadcast_replace_to "games", target: "lobby_members_#{id}", partial: "games/lobby_members"
    end

    if saved_change_to_attribute?(:phase)
      broadcast_prepend_to "lobby_#{id}", target: "meta", partial: "games/add_meta"
    end

    if saved_change_to_attribute?(:step)
      broadcast_render_to "game_#{@game.id}", partial: "games/show_update"
    end
  end

  def all_players_ready?
    game_players.where(ready: false).none?
  end

  def next_step!
    transaction do
      game_players.lock # Блокируем игроков в этой игре
      if all_players_ready?
        update(step: step + 1)
        game_players.update_all(ready: false)
      end
    end
  end
end
