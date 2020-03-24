class AddPlayerFolded < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :folded, :boolean
  end
end
