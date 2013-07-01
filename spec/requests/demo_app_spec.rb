require 'spec_helper'

describe "DemoApp" do

    before do
      stub_request(:post, "http://localhost:3000/oauth/authorize").to_return(
          :status => 200,
          :body => {:status => "OK", :user => { :email => 'citizen.joe@gmail.com' }, :code => 'FAKE_TOKEN' },
          :headers => {'Accept'=>'*/*', 'Authorization'=>'Bearer FAKE_TOKEN', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby' }
        )
       
      return_hash = {
        "provider"=>"mygov",
        "uid"=>nil,
        "info"=>{"email"=>"citizen.joe@gmail.com"},
        "credentials"=> OpenStruct.new({"token"=>"cvbywqr8sfmrrjh0ulxjfh7yt", "expires"=>false}),
        "extra"=>
          OpenStruct.new({"raw_info"=>
            {"title"=>nil,
             "first_name"=>nil,
             "middle_name"=>nil,
             "last_name"=>nil,
             "suffix"=>nil,
             "address"=>nil,
             "address2"=>nil,
             "city"=>nil,
             "state"=>nil,
             "zip"=>nil,
             "phone_number"=>nil,
             "mobile_number"=>nil,
             "date_of_birth"=>nil,
             "gender"=>nil,
             "marital_status"=>nil,
             "is_parent"=>nil,
             "is_retired"=>nil,
             "is_veteran"=>nil,
             "is_student"=>nil,
             "email"=>"citizen.joe@gmail.com"
            }
          })
         }
      OmniAuth.config.mock_auth[:mygov] = OpenStruct.new(return_hash)
    end

  describe "GET /" do
    it "should prompt the user to login" do
      visit root_path
      page.should have_button "MyUSA Account Login"
    end

    it "should log in a user successfully authenticated with MyUSA" do
      visit root_path
      click_button 'MyUSA Account Login'
      page.should have_content 'Currently logged in as: citizen.joe@gmail.com'
    end
  end

end