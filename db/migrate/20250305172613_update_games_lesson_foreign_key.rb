class UpdateGamesLessonForeignKey < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :games, :lessons
    add_foreign_key :games, :lessons, on_delete: :nullify
  end
end
