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
    Player.where({:current_game_id => self.id}).each do |player|
      if player.current_bet != 0
        player.current_bet = 0
        player.save
      end
    end

    occupied_seats = Player.select(:seat).where(:current_game_id => self.id).order(:seat).map { |p| p.seat }
    dealer_index = occupied_seats.index(self.dealer)
    self.action_on = occupied_seats.length-1 == dealer_index ? occupied_seats[0] : occupied_seats[dealer_index+1]
    board_count = Card.where(:hand_player_id => 0).length()
    if board_count == 0
      self.flop
    elsif board_count < 5
      self.turn_river
    end
  end

  def advanceHand
    occupied_seats = Player.select(:seat).where(:current_game_id => self.id).order(:seat).map { |p| p.seat }
    dealer_index = occupied_seats.index(self.dealer)
    self.dealer = occupied_seats.length-1 == dealer_index ? occupied_seats[0] : occupied_seats[dealer_index+1]

    multiple_players = Player.where({:current_game_id => self.id, :folded => false}).length > 1
    if multiple_players
      if Card.where(:hand_player_id => 0).length() < 5
        return
      end

      self.revealed = true;
      self.adjustChipCounts(multiple_players)
    else
      self.adjustChipCounts(multiple_players)
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

  def extract_flush(hand)

  end

  def extract_matches(hand)

  end

  def extract_rest(hand)

  end

  def four_of_kind(hand)

  end

  def full_house(hand)

  end

  def top_of_straight(hand)

  end

  def top_cards(hand)

  end

  def top_card(hand)

  end

  def evaluate(hand)
    flush_cards = self.extract_flush(hand)
    matched_cards = nil
    unmatched_cards = nil

    if flush_cards.length() > 0
      top_card = self.top_of_straight(flush_cards)
      if top_card > 0
        return 1500 + top_card
      end

      return 700 + self.top_cards(flush_cards)
    else
      matched_cards = self.extract_matches(hand)
      unmatched_cards = self.extract_rest(hand)
    end

    four_of_kind_value = self.four_of_kind(matched_cards)
    if four_of_kind_value > 0
      return 1200 + four_of_kind_value * 14 + self.top_card(unmatched_cards)
    end

    full_house_value = self.full_house(matched_cards)
    if full_house_value
      return 900 + full_house_value
    end

    top_card = self.top_of_straight(hand)
    if top_card > 0
      return 800 + top_card
    end
  end

  def determine_winner
    players = Player.where({:current_game_id => self.id, :folded => false})
    hands = []

    players.each do |player|
      hands.push(Card.where({:hand_player_id => player.id}))
    end

    hands.map { |hand| self.evaluate(hand) }
    winning_index = hands.index(hands.max)

    return players.at(winning_index)
  end

  def createdby
    return Player.where({ :id => self.creator_id }).at(0).name
  end

end
