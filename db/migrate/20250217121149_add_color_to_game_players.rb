class AddColorToGamePlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :game_players, :color, :string
  end
end
