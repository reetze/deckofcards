class RemoveLocationFromCard < ActiveRecord::Migration[6.0]
  def change
      remove_column :cards, :current_location
  end
end
