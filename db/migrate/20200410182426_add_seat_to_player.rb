class AddSeatToPlayer < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :seat, :integer
  end
end
