class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.string :text, null: false
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
