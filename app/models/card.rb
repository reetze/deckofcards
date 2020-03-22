# == Schema Information
#
# Table name: cards
#
#  id               :integer          not null, primary key
#  back_image       :string
#  current_location :string
#  deck_order       :integer
#  face_image       :string
#  name             :string
#  suit             :string
#  value            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  current_game_id  :integer
#  hand_player_id   :integer
#

class Card < ApplicationRecord
end
