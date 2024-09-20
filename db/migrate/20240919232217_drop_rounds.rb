class DropRounds < ActiveRecord::Migration[7.0]
  def change
    drop_table :rounds
  end
end
