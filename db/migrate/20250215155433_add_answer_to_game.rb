class AddAnswerToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :answer, :string
  end
end
