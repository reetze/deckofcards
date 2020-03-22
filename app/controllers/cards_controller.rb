class CardsController < ApplicationController

  def change_deck
    Card.all.each do |the_card|
      the_card.back_image = params.fetch("query_back_image")
      the_card.save
    end
    redirect_to("/before_we_begin")
  end  
  
  def index
    @cards = Card.all.order({ :created_at => :desc })

    render({ :template => "cards/index.html.erb" })
  end


  def update
    the_id = params.fetch("path_id")
    @card = Card.where({ :id => the_id }).at(0)

    
    @card.current_location = params.fetch("query_current_location")
    @card.deck_order = params.fetch("query_deck_order")
    @card.hand_player_id = params.fetch("query_hand_player_id")
    @card.back_image = params.fetch("query_back_image")
    @card.current_game_id = params.fetch("query_current_game_id")

    if @card.valid?
      @card.save
      redirect_to("/cards/#{@card.id}", { :notice => "Card updated successfully."} )
    else
      redirect_to("/cards/#{@card.id}", { :alert => "Card failed to update successfully." })
    end
  end

end
