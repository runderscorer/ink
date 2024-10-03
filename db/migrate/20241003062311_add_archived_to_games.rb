class AddArchivedToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :archived, :boolean, default: false
  end
end
