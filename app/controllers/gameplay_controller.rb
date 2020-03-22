class CardsController < ApplicationController
  
  def new_hand
    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id})
    game.revealed = false;
    game.save

    # Shuffle the cards
    a = *(1..52)
    b = []
    52.times { |i|
      b.push(a.delete_at(rand(52-i)))
    }

    Card.all.each do |the_card|
      the_card.hand_player_id = nil
      the_card.deck_order = b[the_card.id]
      the_card.save
    end
    # Cards shuffled

    deck = Card.order(:deck_order)
    players = Player.where({ :current_game_id => game_id})

    # Deal 2 cards to each player
    top = 0
    2.times {
      players.each do |player|
        deck[top].hand_player_id = player.id
        deck[top].save
        top += 1
      end
    }
    # Cards dealt
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

  def reveal_cards
    game_id = params.fetch("game_id")
    game = Game.where({:id => game_id})
    game.revealed = true;
    game.save
  end

end
