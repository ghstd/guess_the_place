class DeleteCoordsAndMembersFromGames < ActiveRecord::Migration[8.0]
  def change
    remove_column :games, :coords
    remove_column :games, :members
  end
end
