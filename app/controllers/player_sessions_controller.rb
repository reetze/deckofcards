class PlayerSessionsController < ApplicationController
  skip_before_action(:force_player_sign_in, { :only => [:new_session_form, :create_cookie] })

  def new_session_form
    render({ :template => "player_sessions/sign_in.html.erb" })
  end

  def create_cookie
    player = Player.where({ :email => params.fetch("query_email") }).at(0)
    
    the_supplied_password = params.fetch("query_password")
    
    if player != nil
      are_they_legit = player.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/player_sign_in", { :alert => "Incorrect password." })
      else
        session.store(:player_id, player.id)
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/player_sign_in", { :alert => "No player with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end
 
end
