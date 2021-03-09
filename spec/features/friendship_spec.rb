require 'rails_helper'

RSpec.describe 'Invitation', type: :system do
  describe 'button' do
    def sign_up_user
      visit new_user_registration_path
      user_name = Faker::Name.name
      user_password = Faker::Internet.password
      fill_in 'Name', with: user_name
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: user_password
      fill_in 'Password confirmation', with: user_password
      click_button 'Sign up'
      visit users_path
      expect(page).to have_content("Logged in as: #{user_name}")
    end
    it 'sends an invitation to another user' do
      sign_up_user
      click_link 'Sign out'
      sign_up_user
      visit users_path
      click_button 'Invite'
      expect(page).to have_content('Pending')
      click_link 'Sign out'
    end
  end
end
