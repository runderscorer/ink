class AddResponseIdTovotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :response_id, :integer
  end
end
