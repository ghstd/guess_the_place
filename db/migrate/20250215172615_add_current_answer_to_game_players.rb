class AddCurrentAnswerToGamePlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :game_players, :current_answer, :string
  end
end
