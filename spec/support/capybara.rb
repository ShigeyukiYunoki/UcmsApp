Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end

def full_title(page_title = '')
  base_title = 'UcmsApp'
  if page_title.empty?
    base_title
  else
    "#{page_title}|#{base_title}"
  end
end
