class AddPhaseAndCreatorToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :phase, :string, default: "lobby"
    add_column :games, :creator, :string
  end
end
