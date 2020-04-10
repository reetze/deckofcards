class AddChipCountToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :chip_count, :integer
  end
end
