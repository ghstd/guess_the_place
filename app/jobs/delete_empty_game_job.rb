class DeleteEmptyGameJob < ApplicationJob
  self.queue_adapter = :async

  def perform(game_id)
    ActiveRecord::Base.connection_pool.with_connection do
      game = Game.find_by(id: game_id)
      if game&.game_players.where(connection: "online").none?
        game.update(phase: "delete")
      end
    end
  end
end
