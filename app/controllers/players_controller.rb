class PlayersController < ApplicationController
  # skip_before_action(:force_player_sign_in, { :only => [:new_registration_form, :create] })
  
  def new_registration_form
    render({ :template => "player_sessions/sign_up.html.erb" })
  end

  def create
    @player = Player.new
    @player.email = params.fetch("query_email")
    @player.password = params.fetch("query_password")
    @player.password_confirmation = params.fetch("query_password_confirmation")
    @player.name = params.fetch("query_name")
    @player.image = params.fetch("query_image")

    save_status = @player.save

    if save_status == true
      session.store(:player_id,  @player.id)
   
      redirect_to("/", { :notice => "Player account created successfully."})
    else
      redirect_to("/player_sign_up", { :alert => "Player account failed to create successfully."})
    end
  end
    
  def edit_registration_form
    render({ :template => "players/edit_profile.html.erb" })
  end

  def update
    @player = @current_player
    @player.email = params.fetch("query_email")
    @player.password = params.fetch("query_password")
    @player.password_confirmation = params.fetch("query_password_confirmation")
    @player.name = params.fetch("query_name")
    @player.image = params.fetch("query_image")
    
    if @player.valid?
      @player.save

      redirect_to("/edit_player_profile", { :notice => "Player account updated successfully."})
    else
      render({ :template => "players/edit_profile_with_errors.html.erb" })
    end
  end

  def destroy
    @current_player.destroy
    reset_session
    
    redirect_to("/", { :notice => "Player account cancelled" })
  end
  
end
