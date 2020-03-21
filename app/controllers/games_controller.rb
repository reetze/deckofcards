class GamesController < ApplicationController
  def index
    @games = Game.all.order({ :created_at => :desc })

    render({ :template => "games/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @game = Game.where({:id => the_id }).at(0)

    render({ :template => "games/show.html.erb" })
  end

  def create
    @game = Game.new
    @game.passcode = params.fetch("query_passcode")
    @game.creator_id = params.fetch("query_creator_id")

    if @game.valid?
      @game.save
      redirect_to("/games", { :notice => "Game created successfully." })
    else
      redirect_to("/games", { :notice => "Game failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @game = Game.where({ :id => the_id }).at(0)

    @game.passcode = params.fetch("query_passcode")
    @game.creator_id = params.fetch("query_creator_id")

    if @game.valid?
      @game.save
      redirect_to("/games/#{@game.id}", { :notice => "Game updated successfully."} )
    else
      redirect_to("/games/#{@game.id}", { :alert => "Game failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @game = Game.where({ :id => the_id }).at(0)

    @game.destroy

    redirect_to("/games", { :notice => "Game deleted successfully."} )
  end
end
