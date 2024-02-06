class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.references :game
      t.references :player
      t.text :prompt

      t.timestamps
    end
  end
end
