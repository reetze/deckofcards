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

  def players_in
    return Player.where({ :current_game_id => self.id})
  end

end
