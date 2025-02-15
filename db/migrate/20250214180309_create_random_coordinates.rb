class CreateRandomCoordinates < ActiveRecord::Migration[8.0]
  def change
    create_table :random_coordinates do |t|
      t.float :lat
      t.float :long
      t.timestamps
    end
  end
end
