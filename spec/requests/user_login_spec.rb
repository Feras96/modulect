require 'rails_helper'

feature "Logging in" do

  given(:user) { create(:user) }

  scenario "as an activated user" do
    visit login_path
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: "password"
      click_button "Log in"
    end
    expect(page).to have_current_path(root_path)
  end

  scenario "as a user that has not been activated" do
    user.update_columns(activated: false, activated_at: nil)
    visit login_path
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: "password"
      click_button "Log in"
    end
    expect(page).to have_current_path(root_path)
  end

  scenario "with invalid credentials" do
    visit login_path
    within("#login-area") do
      click_button "Log in"
    end
    expect(page).to have_current_path(login_path)
  end
end
