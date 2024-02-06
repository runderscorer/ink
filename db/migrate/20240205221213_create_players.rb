class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :game, null: false
      t.string     :name, null: false

      t.timestamps
    end
  end
end
