class HomeController < ApplicationController
  before_filter :merge_params_to_session
  before_filter :setup_mygov_client
  before_filter :set_continue_path_for_form, :only => [:info]
  before_filter :transform_date_of_birth_to_string
  
  def oauth_callback
    if session[:code]
      access_token = @mygov_client.auth_code.get_token(session[:code], :redirect_uri => oauth_callback_url)
      session[:token] = access_token.token
      @access_token = OAuth2::AccessToken.new(@mygov_client, session[:token])
      session[:user] = JSON.parse(@access_token.get("/api/profile.json").body)["user"]
    end
    redirect_to session[:return_to]
  end

  def index
  end
  
  def start
    if params[:reasons].nil?
      flash[:error] = "Please select at least one reason."
      redirect_to :back
    else
      @button_to_path = info_path(@app)
    end
    @mygov_authorize_url = @mygov_client.auth_code.authorize_url(:redirect_uri => oauth_callback_url)
    session[:return_to] = info_path(:step => 'review')
  end
    
  def info
    render :action => params[:step].to_sym
  end
    
  def forms
  end
  
  def save
    if @access_token
      task_items = []
      task_items << {:form_id => 1} if session[:reasons][:married].present?
      task_items << {:form_id => 2} if session[:reasons][:court_order].present?
      response = @access_token.post("/api/tasks", :params => {:task => {:name => 'Change your name', :task_items_attributes => task_items}})
      if response.status == 200
        session[:task] = JSON.parse(response.body)[:task]
        redirect_to finish_path
      else
        flash[:error] = JSON.prase(response.body)["message"]
        redirect_to :back
      end
    else
      session[:return_to] = finish_url
      redirect_to @mygov_client.auth_code.authorize_url(:redirect_uri => oauth_callback_url)
    end
  end
  
  def finish
    redirect_to "#{MYGOV_HOME}/tasks/#{@session[:task][:id]}"
  end
  
  private
  
  def merge_params_to_session
    session.deep_merge!(params)
  end
  
  def setup_mygov_client
    @mygov_client = OAuth2::Client.new(MYGOV_CLIENT_ID, MYGOV_SECRET_ID, :site => 'http://localhost:3001', :token_url => "/oauth/authorize")
  end
  
  def set_continue_path_for_form
    @continue_path = (params[:mode] == "review" ? info_path(:step => 'review') : nil)
  end
  
  def transform_date_of_birth_to_string
    if session["user"] and session["user"]["date_of_birth"] and session["user"]["date_of_birth"].respond_to?(:to_hash)
      dob = session["user"]["date_of_birth"]
      session["user"]["date_of_birth"] = Date.parse("#{dob["year"]}-#{dob["month"]}-#{dob["day"]}").to_s
    end
  end
end