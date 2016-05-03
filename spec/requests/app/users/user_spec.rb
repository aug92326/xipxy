require "request_helper"

describe "user registration", js: true do
  fixtures :users

  it "allows new users to register with an email address and password" do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    visit registration_path

    within 'form' do
      fill_in "email", with: "test_100@mail.com"
      fill_in "password", with: "1qaz!QAZ"
      fill_in "password_confirmation", with: "1qaz!QAZ"

      click_button 'request registration'

      sleep 5
    end

    message = ActionMailer::Base.deliveries.last.to_s

    unless message.match(/confirmation_token=\w*/).nil?
      visit message[message.index(/<a href="/) + 30..message.index(/">Confirm my account/) - 1]
      page.should have_content("Please login or")
    end
  end

  it "allows users how forgot password to re-sent with an email address" do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    user = users(:bar)

    visit forgot_password_path

    within 'form' do
      fill_in 'email', with: user.email
      click_button 'request for change password'

      sleep 3
    end

    message = ActionMailer::Base.deliveries.last.to_s
    unless message.match(/>Someone has requested a link to change your password. You can do this through the link below\w*/).nil?
      page.should have_content("Please login or")
    end
  end

  # it "allows users login by email" do
  #   user = users(:bar)
  #
  #   visit root_path
  #
  #   page.should have_content("Please login or")
  #
  #   within 'form' do
  #     fill_in 'login', with: user.email
  #     fill_in 'password', with: '1qaz!QAZ'
  #     click_button 'login'
  #
  #     sleep 3
  #   end
  #
  #   page.should have_content("Welcome #{user.username}")
  # end
end