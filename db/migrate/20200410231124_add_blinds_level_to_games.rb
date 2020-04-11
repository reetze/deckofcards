class AddBlindsLevelToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :blinds_level, :integer
  end
end
