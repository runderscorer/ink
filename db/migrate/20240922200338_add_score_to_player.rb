class AddScoreToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :score, :integer, default: 0
  end
end
