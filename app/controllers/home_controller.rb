class HomeController < ApplicationController
  before_filter :setup_session_user
  before_filter :reset_session, :only => [:start]
  before_filter :merge_params_to_session
  before_filter :setup_mygov_client
  before_filter :setup_mygov_access_token
  before_filter :set_continue_path_for_form, :only => [:info]
  before_filter :transform_date_of_birth_to_string
  before_filter :transform_phone_numbers
  
  def oauth_callback
    auth = request.env["omniauth.auth"]
    session[:user] = auth.extra.raw_info.to_hash
    session[:token] = auth.credentials.token
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
    session[:return_to] = info_path(:step => 'review')
  end
    
  def info
    render :action => params[:step].to_sym
  end
    
  def forms
  end
  
  def fill_pdf
    puts "#{MYGOV_FORMS_HOME}/api/forms/#{params[:id]}/fill_pdf"
    response = HTTParty.post("#{MYGOV_FORMS_HOME}/api/forms/#{params[:id]}/fill_pdf", :body => {:data => session["user"]})
    puts response.code
    if response.code == 200
      send_data response.body, :type => "application/pdf", :filename => "#{params[:id]}.pdf"
    else
      flash[:error] = "Sorry, something went wrong.  Horribly, horribly wrong."
      render :forms
    end
  end
  
  def save
    if @mygov_access_token
      store_form_data
      tasks = create_tasks
      if tasks["status"] == "OK"
        redirect_to finish_path
      else
        flash[:error] = JSON.parse(response.body)["message"]
        redirect_to :back
      end
    else
      session[:return_to] = save_url
      redirect_to "/auth/mygov"
    end
  end
  
  def finish
  end
  
  private
  
  def setup_session_user
    session[:user] = {} if session[:user].nil?
  end
  
  def setup_mygov_client
    @mygov_client = OAuth2::Client.new(MYGOV_CLIENT_ID, MYGOV_SECRET_ID, MYGOV_CLIENT_OPTIONS)
  end

  def setup_mygov_access_token
    @mygov_access_token = OAuth2::AccessToken.new(@mygov_client, session[:token]) if session
  end

  def merge_params_to_session
    session.deep_merge!(params)
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
  
  def transform_phone_numbers
    if params[:user]
      params[:user][:phone_number].gsub!(/-/, "") if params[:user][:phone_number]
      params[:user][:mobile_number].gsub!(/-/, "") if params[:user][:mobile_number]
    end
  end
  
  def store_form_data
    form_number = 'ss-5' if session[:reasons][:married].present?
    form_number = '79960' if session[:reasons][:court_order].present?
    body = {}
    body.merge!(:form_number => form_number)
    body.merge!(:data => session[:user])
    @mygov_access_token.post("/api/forms", :body => body)
  end
  
  def create_tasks
    task_items = []
    task_items << {:name => 'Get a new Social Security card', :url => 'http://www.socialsecurity.gov/online/ss-5.pdf'} if session[:reasons][:married].present?
    task_items << {:name => 'Renew your passport', :url => 'http://www.state.gov/documents/organization/79960.pdf'} if session[:reasons][:court_order].present?
    tasks_response = @mygov_access_token.post("/api/tasks", :params => {:task => {:name => 'Change your name', :task_items_attributes => task_items}})
    JSON.parse(tasks_response.body)
  end
end