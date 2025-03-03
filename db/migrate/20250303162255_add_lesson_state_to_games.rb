class AddLessonStateToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :lesson_state, :text
  end
end
