require 'spec_helper'

describe 'Session', :js => true do
  feature "Signing in" do
  background do
    FactoryGirl.create :user, email: 'test@example.com', password: 'password'
  end

    scenario "Signing in with correct credentials" do
      visit '/api'
        click_link('sessions')
        sleep(1)
        click_link('api/sessions.json')
        fill_in 'email', :with => 'user@example.com'
        fill_in 'password', :with => 'password'
        sleep(1)
        click_button('Try it out!')
        sleep(2)
        expect(page).to have_content '200'
    end
    scenario "Signing in with wrong correct credentials" do
      visit '/api'
        click_link('sessions')
        sleep(1)
        click_link('api/sessions.json')
        fill_in 'email', :with => 'user@example.com'
        fill_in 'password', :with => 'bad_password'
        sleep(1)
        click_button('Try it out!')
        sleep(2)
        expect(page).to have_content '401'
    end
  end
end