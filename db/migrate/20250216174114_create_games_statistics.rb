class CreateGamesStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :games_statistics do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :game_type
      t.integer :questions
      t.integer :answers

      t.timestamps
    end
  end
end
