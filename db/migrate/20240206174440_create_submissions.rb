class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.references :round
      t.references :player
      t.text :text

      t.timestamps
    end
  end
end
