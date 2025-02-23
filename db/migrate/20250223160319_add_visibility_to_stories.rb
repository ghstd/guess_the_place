class AddVisibilityToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :visibility, :string, default: "visible"
  end
end
