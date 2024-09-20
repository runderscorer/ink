class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, foreign_key: true
      t.string :text, null: false
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
