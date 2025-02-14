class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.integer :steps, default: 0
      t.text :coords
      t.text :members
      t.timestamps
    end
  end
end
