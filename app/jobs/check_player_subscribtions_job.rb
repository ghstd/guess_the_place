class CheckPlayerSubscribtionsJob < ApplicationJob
  self.queue_adapter = :async

  def perform(player_id)
    player = GamePlayer.find_by(id: player_id)

    if player.subscribtions.any?
      if player.connection != "online"
        player.update(connection: "online")
      end

      return
    end

    player.update(connection: "offline")
  end
end
