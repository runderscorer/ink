class UpdateVotes < ActiveRecord::Migration[7.0]
  def change
    remove_column :votes, :submission_id, :integer
  end
end
