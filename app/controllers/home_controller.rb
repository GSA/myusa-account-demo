class HomeController < ApplicationController
  before_filter :merge_params_to_session
  before_filter :setup_mygov_client
  before_filter :setup_user_from_token, :except => [:index, :start, :oauth_callback]
  before_filter :set_continue_path_for_form, :only => [:info, :address, :birthdate, :contact_info]
  
  # TODO: put this all into a single action that has a param for steps, so we dont have so many actions
  # TODO: stuff is not properly saved to the session since we are looking up profile with each step
  #   instead look up profile once in beginning and use that to prepopulate but save user changes.
  
  def index
  end
  
  def start
    if params[:reason].nil?
      flash[:error] = "Please select at least one reason."
      redirect_to :back
    else
      @button_to_path = info_path(@app)
    end
    @mygov_authorize_url = @mygov_client.auth_code.authorize_url(:redirect_uri => oauth_callback_url)
    session[:return_to] = review_path
  end
  
  # TODO: move this to another controller
  def oauth_callback
    if session[:code]
      access_token = @mygov_client.auth_code.get_token(session[:code], :redirect_uri => oauth_callback_url)
      session[:token] = access_token.token
    end
    redirect_to session[:return_to]
  end
  
  def info
  end
  
  def address
  end
  
  def birthdate
  end

  def contact_info
  end
  
  def review
  end
  
  def forms
  end
  
  def save
    # Here we are going to use the MyGov Tasks API to create a task for the user representing the forms that they need to fill out
    # If the user has already authorized MyGov, great, we use the API.
    # If the user has not, we once again offer them to sign up for MyGov.  We can transfer profile information when creating the account
    if @access_token
      #@access_token.post("/tasks", {})
      redirect_to finish_path
    else
      session[:return_to] = finish_url
      redirect_to @mygov_client.auth_code.authorize_url(:redirect_uri => oauth_callback_url)
    end
  end
  
  def finish
    # @tasks = @access_token.get("/tasks.json")
  end
  
  private
  
  def merge_params_to_session
    session.merge!(params)
  end
  
  def setup_mygov_client
    @mygov_client = OAuth2::Client.new(MYGOV_CLIENT_ID, MYGOV_SECRET_ID, :site => 'http://localhost:3001', :token_url => "/oauth/authorize")
  end
  
  def setup_user_from_token
    if session[:token]
      @access_token = OAuth2::AccessToken.new(@mygov_client, session[:token])
      session[:user] = JSON.parse(@access_token.get("/profile.json").body)["user"].symbolize_keys
    elsif session[:user].nil?
      session[:user] = {}
    end
  end
  
  def set_continue_path_for_form
    @continue_path = (params[:mode] == "review" ? review_path : nil)
  end
end