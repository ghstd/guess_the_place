class CreateLessonAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_answers do |t|
      t.references :lesson_question, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
