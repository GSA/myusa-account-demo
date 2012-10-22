require 'spec_helper'

describe "ChangeYourName" do
  describe "GET /" do
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
      
      page.should have_content 'Good job! Now we\'re going to take all that info you gave us and pre-fill as much of the form(s) as we can.'
      page.should have_content 'Download SS-5 (PDF)'
      page.should_not have_content 'Download Passport Form'
      click_link 'Save and continue to forms'
      
      page.should have_content 'We will show you tasks here.'
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
      # click_link 'Use MyGov'
      
      # fake-login the user
      session[:user] = { title: 'Mr.', first_name: 'Joe', middle_name: 'Q.', last_name: 'Citizen', address: '123 Evergreen Terr', city: 'Springfield', state: 'IL', zip: 12345, date_of_birth: Date.parse('1990-01-01'), phone_number: '123-345-5667', email: 'joe@citizen.org' }
      
      visit info_path(:step => 'review')
      page.should have_content 'Mr. Joe Q. Citizen'
      page.should have_content '123 Evergreen Terr'
      page.should have_content 'Sprinfield, IL 12345'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit name'
      fill_in 'First name', :with => 'Joseph'
      fill_un 'Middle name', :with => 'Quiggley'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '123 Evergreen Terr'
      page.should have_content 'Sprinfield, IL 12345'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit address'
      fill_in 'Address', :with => '1234 Evergreen Terr'
      fill_in 'Zip code', :with => '23456'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Sprinfield, IL 23456'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit date of birth'
      select '1991', :from => 'user_date_of_birth_year'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Sprinfield, IL 23456'
      page.should have_content '1991-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-345-5667'
      
      click_button 'Edit contact information'
      fill_in 'Home phone', :with => '123-456-7890'
      fill_in 'Mobile phone', :with => '234-567-8901'
      click_button 'Continue'
      page.should have_content 'Mr. Joseph Quiggley Citizen'
      page.should have_content '1234 Evergreen Terr'
      page.should have_content 'Sprinfield, IL 23456'
      page.should have_content '1990-01-01'
      page.should have_content 'joe@citizen.org'
      page.should have_content '123-456-7890'
      page.should have_content '234-567-8901'
      
      click_button 'Continue to Download Forms'
      
      page.should have_content 'Good job! Now we\'re going to take all that info you gave us and pre-fill as much of the form(s) as we can.'
      page.should have_content 'Download SS-5 (PDF)'
      page.should_not have_content 'Download Passport Form'
      click_link 'Save and continue to forms'
      
      page.should have_content 'We will show you tasks here.'
    end
  end
end