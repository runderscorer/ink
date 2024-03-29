class AddHostToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :host, :boolean, default: false
  end
end
