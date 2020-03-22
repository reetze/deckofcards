class AddRevealedToCard < ActiveRecord::Migration[6.0]
  def change
      add_column :cards, :revealed, :boolean
  end
end
