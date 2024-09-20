class AddColumnToResponse < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :prompt_id, :integer
  end
end
