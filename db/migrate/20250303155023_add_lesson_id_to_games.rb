class AddLessonIdToGames < ActiveRecord::Migration[8.0]
  def change
    add_reference :games, :lesson, foreign_key: true
  end
end
