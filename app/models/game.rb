class Game < ApplicationRecord
  serialize :coords, coder: JSON
  serialize :members, coder: JSON

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
  end
end
