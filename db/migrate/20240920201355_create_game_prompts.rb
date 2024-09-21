class CreateGamePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :game_prompts do |t|
      t.references :game, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end