class CreateStreets < ActiveRecord::Migration[8.0]
  def change
    create_table :streets do |t|
      t.string :name

      t.timestamps
    end
  end
end
