class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :player
      t.references :response
      t.integer :kind

      t.timestamps
    end
  end
end
