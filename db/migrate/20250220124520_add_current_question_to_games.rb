class AddCurrentQuestionToGames < ActiveRecord::Migration[8.0]
  def change
    add_reference :games, :current_question, foreign_key: { to_table: :story_questions }
  end
end
