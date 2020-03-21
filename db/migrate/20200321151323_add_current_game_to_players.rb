class AddCurrentGameToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :current_game_id, :integer
  end
end
