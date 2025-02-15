class CreateGameCoordinates < ActiveRecord::Migration[8.0]
  def change
    create_table :game_coordinates do |t|
      t.float :lat
      t.float :long
      t.timestamps
    end
  end
end
