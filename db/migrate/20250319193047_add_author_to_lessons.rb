class AddAuthorToLessons < ActiveRecord::Migration[8.0]
  def change
    add_column :lessons, :author, :integer
  end
end
