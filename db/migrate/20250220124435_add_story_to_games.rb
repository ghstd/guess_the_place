class AddStoryToGames < ActiveRecord::Migration[8.0]
  def change
    add_reference :games, :story, foreign_key: true
  end
end
