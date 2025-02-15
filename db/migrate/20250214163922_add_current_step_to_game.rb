class AddCurrentStepToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :current_step, :integer, default: 1
  end
end
