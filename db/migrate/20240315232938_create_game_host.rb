class CreateGameHost < ActiveRecord::Migration[7.0]
  def change
    create_table :game_hosts do |t|
      t.references :game, null: false, foreign_key: { on_delete: :cascade }
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
