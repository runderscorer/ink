class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :player
      t.references :submission

      t.timestamps
    end
  end
end
