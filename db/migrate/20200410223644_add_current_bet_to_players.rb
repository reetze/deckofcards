class AddCurrentBetToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :current_bet, :integer
  end
end
