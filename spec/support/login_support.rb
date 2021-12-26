module LoginSupport
  def sign_in_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    find('#login').click
    expect(current_path).to eq user_path(user)
    find('.swal-button--gotit').click
    # expect(page).to have_content('Good job!')
    # click_on 'OK'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
