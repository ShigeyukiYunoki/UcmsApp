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
    if ENV['SELENIUM_DRIVER_URL'].present?
      driven_by :selenium, using: :chrome, options: {
        browser: :remote,
        # webコンテナ側からchromeコンテナのchromeを使用するために、
        # optionsの中で、urlにSELENIUM_DRIVER_URL環境変数の値を設定
        url: ENV.fetch('SELENIUM_DRIVER_URL'),
        desired_capabilities: :chrome
      }
    else
      driven_by :selenium_chrome_headless
      # 3.1) Failure/Error: visit login_path
      #
      #     SocketError:
      #       getaddrinfo: Name or service not known
          # ./spec/support/login_support.rb:3:in `sign_in_as'
          # ./spec/system/comments_spec.rb:11:in `block (3 levels) in <main>'
          # ./spec/system/comments_spec.rb:10:in `block (2 levels) in <main>'

     # 3.2) Failure/Error: server = TCPServer.new(host, 0)
     #
     #      SocketError:
     #        getaddrinfo: Name or service not known
     # 下記が存在すると上記のエラーがrspecで発生する
      # headless chromeからはローカル環境ではなくwebコンテナ側のrailsアプリを表示してテストする必要があるため
      # Capybara.server_host = 'web'
      # Capybara.app_host='http://web'
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
