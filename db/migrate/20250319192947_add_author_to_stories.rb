class AddAuthorToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :author, :integer
  end
end
