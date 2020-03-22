Rails.application.routes.draw do

  # Routes for the Game resource:

  # CREATE
  post("/insert_game", { :controller => "games", :action => "create" })
  get("/create_or_join", { :controller => "games", :action => "create_or_join" })
  post("/take_a_seat", { :controller => "games", :action => "sit_down" })
          
  # READ
  get("/games", { :controller => "games", :action => "index" })
  get("/games/:path_id", { :controller => "games", :action => "show" })
  post("/join_game", { :controller => "games", :action => "join" })
   get("/before_we_begin", { :controller => "games", :action => "pre_game" })
  
  # UPDATE
  
  post("/modify_game/:path_id", { :controller => "games", :action => "update" })
  
  # DELETE
  get("/delete_game/:path_id", { :controller => "games", :action => "destroy" })

  #------------------------------

  # Routes for the Player account:

  # SIGN UP FORM
  get("/player_sign_up", { :controller => "players", :action => "new_registration_form" })        
  # CREATE RECORD
  post("/insert_player", { :controller => "players", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_player_profile", { :controller => "players", :action => "edit_registration_form" })       
  # UPDATE RECORD
  post("/modify_player", { :controller => "players", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_player_account", { :controller => "players", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/player_sign_in", { :controller => "player_sessions", :action => "new_session_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/player_verify_credentials", { :controller => "player_sessions", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/player_sign_out", { :controller => "player_sessions", :action => "destroy_cookies" })
             
  #------------------------------

  # ======= Add Your Routes Above These =============
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
