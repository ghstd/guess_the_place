class AddGameIdToGameCoordinates < ActiveRecord::Migration[8.0]
  def change
    add_reference :game_coordinates, :game, null: false, foreign_key: true
  end
end
