# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  passcode   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :integer
#

class Game < ApplicationRecord

  belongs_to :creator, :class_name => "Player"
  has_many :players, :foreign_key => "current_game_id"

  def players_in
    return Player.where({ :current_game_id => self.id})
  end

end
