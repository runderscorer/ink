class AddGameIdToResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :game_id, :integer
  end
end
