class GameplayController < ApplicationController

  def GameplayController.shuffle
    a = *(1..52)
    b = []
    52.times { |i|
      b.push(a.delete_at(rand(52-i)))
    }

    Card.all.each do |the_card|
      the_card.hand_player_id = nil
      the_card.deck_order = b[the_card.id-1]
      the_card.save
    end
  end

  def GameplayController.deal(game_id)
    deck = Card.order(:deck_order)
    players = Player.where({ :current_game_id => game_id})

    top = 0
    2.times {
      players.each do |player|
        player.folded = false
        player.save
        deck[top].hand_player_id = player.id
        deck[top].save
        top += 1
      end
    }
  end

  def GameplayController.blinds(game)
    occupied_seats = Player.select(:seat).where(:current_game_id => game.id).order(:seat).map { |p| p.seat }
    dealer_index = occupied_seats.index(game.dealer)
    small_blind = occupied_seats.length-1 == dealer_index ? occupied_seats[0] : occupied_seats[dealer_index+1]
    small_blind_index = occupied_seats.index(small_blind)
    big_blind = occupied_seats.length-1 == small_blind_index ? occupied_seats[0] : occupied_seats[small_blind_index+1]
    big_blind_index = occupied_seats.index(big_blind)
    under_the_gun = occupied_seats.length-1 == big_blind_index ? occupied_seats[0] : occupied_seats[big_blind_index+1]

    small_blind_player = Player.where(:seat => small_blind).where(:current_game_id => game.id).at(0)
    small_blind_player.current_bet = [small_blind_player.chip_count, 10*(2**game.blinds_level)].min
    small_blind_player.chip_count -= small_blind_player.current_bet
    small_blind_player.save

    big_blind_player = Player.where(:seat => big_blind).where(:current_game_id => game.id).at(0)
    big_blind_player.current_bet = [big_blind_player.chip_count, 20*(2**game.blinds_level)].min
    big_blind_player.chip_count -= big_blind_player.current_bet
    big_blind_player.save

    game.pot = small_blind_player.current_bet + big_blind_player.current_bet
    game.action_on = under_the_gun
    game.save
  end

  def new_hand
    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id}).at(0)
    game.revealed = false;
    game.save

    GameplayController.shuffle
    GameplayController.deal(game_id)
    GameplayController.blinds(game)
  end

  def flop
    if Card.where(:hand_player_id => 0).length() != 0
      return
    end

    deck = Card.where(:hand_player_id => nil).order(:deck_order)

    3.times { |top|
      deck[top].hand_player_id = 0
      deck[top].save
    }
  end

  def turn_river
    table_cards = Card.where(:hand_player_id => 0).length()
    if table_cards > 4 or table_cards < 3
      return
    end

    top_card = Card.where(:hand_player_id => nil).order(:deck_order).at(0)
    top_card.hand_player_id = 0
    top_card.save
  end

  def reveal_cards
    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id}).at(0)
    game.revealed = true;
    game.save
  end

  def check
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    game = Game.where({ :id => player.current_game_id}).at(0)
    if player.seat != game.action_on
      return
    end

    max_bet = Player.where({ :current_game_id => game.id}).select(:current_bet).map { |p| p.current_bet }.max
    if max_bet != player.current_bet
      return
    end

    game.advanceAction
  end

  def call
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    game = Game.where({ :id => player.current_game_id}).at(0)
    if player.seat != game.action_on
      return
    end

    max_bet = Player.where({ :current_game_id => game.id}).select(:current_bet).map { |p| p.current_bet }.max
    amount_to_call = max_bet - player.current_bet
    player.chip_count -= amount_to_call
    player.current_bet = max_bet
    player.save

    game.advanceAction
  end

  def raise
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    game = Game.where({ :id => player.current_game_id}).at(0)
    if player.seat != game.action_on
      return
    end

    bet_amount = params.fetch("bet_amount")
    player.current_bet+ = bet_amount
    player.chip_count -= bet_amount
    player.save

    game.pot += bet_amount
    game.advanceAction
  end

  def fold
    player = Player.where({ :id => session.fetch(:player_id)}).at(0)
    game = Game.where({ :id => player.current_game_id}).at(0)
    if player.seat != game.action_on
      return
    end

    game.advanceAction # Do this first so that current player isn't folded yet.

    player.folded = true
    player.save
  end

end
