class CardsController < ApplicationController
  def index
    @cards = Card.all.order({ :created_at => :desc })

    render({ :template => "cards/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @card = Card.where({:id => the_id }).at(0)

    render({ :template => "cards/show.html.erb" })
  end

  def create
    @card = Card.new
    @card.suit = params.fetch("query_suit")
    @card.name = params.fetch("query_name")
    @card.value = params.fetch("query_value")
    @card.back_image = params.fetch("query_back_image")
    @card.face_image = params.fetch("query_face_image")

    if @card.valid?
      @card.save
      redirect_to("/cards", { :notice => "Card created successfully." })
    else
      redirect_to("/cards", { :notice => "Card failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @card = Card.where({ :id => the_id }).at(0)

    @card.suit = params.fetch("query_suit")
    @card.name = params.fetch("query_name")
    @card.value = params.fetch("query_value")
    @card.current_location = params.fetch("query_current_location")
    @card.deck_order = params.fetch("query_deck_order")
    @card.hand_player_id = params.fetch("query_hand_player_id")
    @card.back_image = params.fetch("query_back_image")
    @card.face_image = params.fetch("query_face_image")
    @card.current_game_id = params.fetch("query_current_game_id")

    if @card.valid?
      @card.save
      redirect_to("/cards/#{@card.id}", { :notice => "Card updated successfully."} )
    else
      redirect_to("/cards/#{@card.id}", { :alert => "Card failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @card = Card.where({ :id => the_id }).at(0)

    @card.destroy

    redirect_to("/cards", { :notice => "Card deleted successfully."} )
  end
end
