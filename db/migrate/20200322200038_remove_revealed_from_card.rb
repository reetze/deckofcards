class RemoveRevealedFromCard < ActiveRecord::Migration[6.0]
  def change
      remove_column :cards, :revealed, :boolean
      add_column :games, :revealed, :boolean
  end
end
