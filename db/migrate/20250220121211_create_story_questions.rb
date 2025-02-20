class CreateStoryQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :story_questions do |t|
      t.references :story, null: false, foreign_key: true
      t.string :question
      t.string :answer
      t.text :options
      t.text :coordinates

      t.timestamps
    end
  end
end
