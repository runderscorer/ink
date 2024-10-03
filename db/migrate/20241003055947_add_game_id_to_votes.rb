class AddGameIdToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :game_id, :integer
  end
end
