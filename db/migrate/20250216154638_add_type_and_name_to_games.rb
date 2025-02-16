class AddTypeAndNameToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :game_type, :string
    add_column :games, :name, :string
  end
end
