# == Schema Information
#
# Table name: games
#
#  id           :integer          not null, primary key
#  action_on    :integer
#  blinds_level :integer
#  dealer       :integer
#  passcode     :string
#  pot          :integer
#  revealed     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :integer
#

class Game < ApplicationRecord

  belongs_to :creator, :class_name => "Player"
  has_many :players, :foreign_key => "current_game_id"

  def theplayers
    return Player.where({ :current_game_id => self.id})
  end

  def advanceAction
    actor_order = Player.where({ :current_game_id => self.id, :folded => false}).order(:seat).map { |p| p.seat }
    acting_index = actor_order.index(self.action_on)
    self.action_on = actor_order.length-1 == acting_index ? actor_order[0] : actor_order[acting_index+1]
    self.save
  end

  def createdby
    return Player.where({ :id => self.creator_id }).at(0).name
  end

end
