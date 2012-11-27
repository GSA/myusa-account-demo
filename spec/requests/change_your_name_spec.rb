require 'spec_helper'

describe "ChangeYourName" do
  describe "GET /" do
    before do
      stub_request(:post, "/api/tasks").to_return(:status => 200, :body => {:status => "OK", :task => {:name => 'Change your name', :url => 'http://ssa.gov/form.pdf'} })
      stub_request(:post, "http://localhost:3001/api/forms").
               with(:body => {"data"=>{"id"=>"12345", "title"=>"Mr.", "first_name"=>"Joseph", "middle_name"=>"Quiggley", "last_name"=>"Citizen", "address"=>"1234 Evergreen Terr", "city"=>"Springfield", "state"=>"IL", "zip"=>"23456", "phone_number"=>"1234567890", "mobile_number"=>"2345678901", "email"=>"joe@citizen.org", "date_of_birth"=>"1991-01-01", "suffix"=>"", "address2"=>""}, "form_number"=>"ss-5"},
                    :headers => {'Accept'=>'*/*', 'Authorization'=>'Bearer FAKE_TOKEN', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => "[]", :headers => {})
      stub_request(:post, "http://localhost:3001/api/tasks?task%5Bname%5D=Change%20your%20name&task%5Btask_items_attributes%5D%5Bname%5D=Get%20a%20new%20Social%20Security%20card&task%5Btask_items_attributes%5D%5Burl%5D=http://www.socialsecurity.gov/online/ss-5.pdf").
              with(:headers => {'Accept'=>'*/*', 'Authorization'=>'Bearer FAKE_TOKEN', 'Content-Length'=>'0', 'User-Agent'=>'Ruby'}).
              to_return(:status => 200, :body => '{"status": "OK"}', :headers => {})
    end
    
    it "should require the user to select a reason for changing their name" do
      visit root_path
      click_button 'Continue'
      page.should have_content 'We\'re going to help you fill out the forms you need.'
      page.should have_content 'Please select at least one reason.'
    end

    it "should allow a user to change their name without connecting with a MyGov account" do
      visit root_path
      page.should have_content 'Change your name'
      page.should have_content 'We\'re going to help you fill out the forms you need.'
      check 'Getting Married'
      click_button 'Continue'

      page.should have_content 'Here are the places you\'ll have to change your name.'
      page.should have_content 'Get a new Social Security card with the Social Security Agency'
      page.should_not have_content 'Get a new passport with the State Department'
      click_link 'No thanks'

      page.should have_content 'Your current name'
      select 'Mr.', :from => 'Title / Prefix'
      fill_in 'First name', :with => 'Joe'
      fill_in 'Middle name', :with => 'Q.'
      fill_in 'Last name', :with => 'Citizen'
      click_button 'Continue'

      page.should have_content 'Your primary address'
      fill_in 'Street Address (first line)', :with => '123 Evergreen Terr'
      fill_in 'City or town', :with => 'Springfield'
      select 'Illinois', :from => 'State'
      fill_in 'Zip code', :with => '12345'
      click_button 'Continue'

      page.should have_content "When were you born?"
      select "1990", :from => 'user_date_of_birth_year'
      select "January", :from => 'user_date_of_birth_month'
      select "1", :form => 'user_date_of_birth_day'
      click_button 'Continue'

      page.should have_content "What's the best way to reach you?"
      fill_in 'Email', :with => 'joe.q.citizen@gmail.com'
      fill_in 'Home phone', :with => '123-345-5667'
      click_button 'Continue'

      page.should have_content 'Review your information'
      click_button 'Continue to Download Forms'
      
      page.should have_content "Here's a list of the forms you need to file to complete the process"
      page.should have_content 'Download SS-5 (PDF)'
      page.should_not have_content 'Download Passport Form'
    end
    
    it "should allow a user to skip entering any information and proceed immedieately to downloading forms" do
      visit root_path
      click_link 'No thanks, I\'d rather print out the forms'
      page.should have_content 'Download SS-5 (PDF)'
      page.should have_content 'Download Passport Form'
    end
    
    it "should allow a user to change their name by connecting to a MyGov account" do
      visit root_path
      check 'Getting Married'
      click_button 'Continue'
      click_button 'Use MyGov'
                  
      visit info_path(:step => 'review')
      page.should have_content 'Mr. Joe Q. Citizen'
      page.should have_content '123 Evergreen Terr'
      page.should have_content 'Springfield, IL 12345'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit name'
      fill_in 'First name', :with => 'Joseph'
      fill_in 'Middle name', :with => 'Quiggley'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '123 Evergreen Terr'
      page.should have_content 'Springfield, IL 12345'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit address'
      fill_in 'Address', :with => '1234 Evergreen Terr'
      fill_in 'Zip code', :with => '23456'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Springfield, IL 23456'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit date of birth'
      select '1991', :from => 'user_date_of_birth_year'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Springfield, IL 23456'
      page.should have_content '1991-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit contact information'
      fill_in 'Home phone', :with => '123-456-7890'
      fill_in 'Mobile phone', :with => '234-567-8901'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Springfield, IL 23456'
      page.should have_content '1991-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-456-7890'
      page.should have_content '234-567-8901'
      
      click_button 'Continue to Download Forms'
      
      page.should have_content "Here's a list of the forms you need to file to complete the process"
      page.should have_content 'Download SS-5 (PDF)'
      page.should_not have_content 'Download Passport Form'
      click_link 'Save'
      
      page.should have_content "We've saved your work in your MyGov account"
    end
  end
end