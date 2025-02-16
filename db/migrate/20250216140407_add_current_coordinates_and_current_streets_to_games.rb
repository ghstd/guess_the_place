class AddCurrentCoordinatesAndCurrentStreetsToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :current_coordinates, :text
    add_column :games, :current_streets, :text
  end
end
