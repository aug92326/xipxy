module Helper
  def sign_in_as(user)
    visit '/'
    # within '.navbar-form' do
    #   fill_in 'user_account[email]', with: user.email
    #   fill_in 'user_account[password]', with: 'password'
    #   click_button 'Submit'
    # end
  end

  def screenshot(filename)
    page.driver.render(Rails.root.join('tmp', 'screenshots', "#{filename}.png"))
  end
end