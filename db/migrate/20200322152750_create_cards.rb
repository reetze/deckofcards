class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :suit
      t.string :name
      t.integer :value
      t.string :current_location
      t.integer :deck_order
      t.integer :hand_player_id
      t.string :back_image
      t.string :face_image
      t.integer :current_game_id

      t.timestamps
    end
  end
end
