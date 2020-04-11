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

  def flop
    deck = Card.where(:hand_player_id => nil).order(:deck_order)

    3.times { |top|
      deck[top].hand_player_id = 0
      deck[top].save
    }
  end

  def turn_river
    top_card = Card.where(:hand_player_id => nil).order(:deck_order).at(0)
    top_card.hand_player_id = 0
    top_card.save
  end

  def advanceAction
    actor_order = Player.where({ :current_game_id => self.id, :folded => false}).where.not({:chip_count => 0}).order(:seat).map { |p| p.seat }

    if actor_order.length < 2
      if Card.where({:hand_player_id => 0}).length == 5
        game.advanceHand
      else
        game.advanceBoard
      end
    end

    acting_index = actor_order.index(self.action_on)
    self.action_on = actor_order.length-1 == acting_index ? actor_order[0] : actor_order[acting_index+1]
    self.save
  end

  def advanceBoard
    Players.where({:current_game_id => self.id}).each do |player|
      if player.current_bet != 0
        player.current_bet = 0
        player.save
      end
    end

    self.action_on = self.dealer
    board_count = Card.where(:hand_player_id => 0).length()
    if board_count == 0
      self.flop
    elsif board_count < 5
      self.turn_river
    end
  end

  def advanceHand
    occupied_seats = Player.select(:seat).where(:current_game_id => game.id).order(:seat).map { |p| p.seat }
    dealer_index = occupied_seats.index(game.dealer)
    self.dealer = occupied_seats.length-1 == dealer_index ? occupied_seats[0] : occupied_seats[dealer_index+1]

    multiple_players = Player.where({:current_game_id => self.id, :folded => false}).length > 1
    self.adjustChipCounts(multiple_players)
    if multiple_players
      self.revealed = true;
    else
      #deal new hand
    end

    self.save
  end

  def adjustChipCounts(multiple_players)
    winner = nil
    if multiple_players
      winner = self.determine_winner
    else
      winner = Player.where({:current_game_id => self.id, :folded => false}).at(0)
    end

    winner.chip_count += self.pot
    winner.current_bet = 0
    winner.save
    Players.where({:current_game_id => self.id}).each do |player|
      if player.current_bet != 0
        player.current_bet = 0
        player.save
      end
    end

    self.pot = 0
  end

  def determine_winner
  end

  def createdby
    return Player.where({ :id => self.creator_id }).at(0).name
  end

end
