class AddActionOnToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :action_on, :integer
  end
end
