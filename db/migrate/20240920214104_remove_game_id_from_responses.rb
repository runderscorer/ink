class RemoveGameIdFromResponses < ActiveRecord::Migration[7.0]
  def change
    remove_column :responses, :game_id, :integer
  end
end
