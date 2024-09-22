class AddAuthorToPrompt < ActiveRecord::Migration[7.0]
  def change
    add_column :prompts, :author, :string
  end
end
