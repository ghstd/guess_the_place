class AddSubscribtionsToGamePlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :game_players, :subscribtions, :text, default: "[]"
  end
end
