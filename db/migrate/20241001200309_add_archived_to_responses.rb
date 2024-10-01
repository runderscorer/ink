class AddArchivedToResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :archived, :boolean, default: false
  end
end
