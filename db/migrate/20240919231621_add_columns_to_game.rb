class AddColumnsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :started_at, :datetime
    add_column :games, :ended_at, :datetime
    add_column :games, :winner_id, :integer
  end
end
