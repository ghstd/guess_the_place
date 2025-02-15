class CreateGamePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :game_players do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :ready, default: false
      t.integer :answers, default: 0

      t.timestamps
    end
  end
end
