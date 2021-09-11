Capybara.register_driver :chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    if ENV["SELENIUM_DRIVER_URL"].present?
      driven_by :selenium, using: :chrome, options: {
        browser: :remote,
        #web コンテナ側からselenium_chromeコンテナのchromeを使用するために、
        #optionsの中で、urlにSELENIUM_DRIVER_URL環境変数の値を設定
        url: ENV.fetch("SELENIUM_DRIVER_URL"),
        desired_capabilities: :chrome
      }
    else
      driven_by :selenium_chrome_headless
      # headless chromeからはローカル環境ではなくwebコンテナ側のrailsアプリを表示してテストする必要があるため
      Capybara.server_host = 'web'
      Capybara.app_host='http://web'
    end
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
