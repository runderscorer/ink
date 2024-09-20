class UpdatePrompt < ActiveRecord::Migration[7.0]
  def change
    remove_column :prompts, :game_id
  end
end
