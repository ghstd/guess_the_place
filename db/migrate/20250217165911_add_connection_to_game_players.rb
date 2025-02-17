class AddConnectionToGamePlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :game_players, :connection, :string, default: "offline"
  end
end
