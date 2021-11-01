#encoding: UTF-8
require 'cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'rest-client'
require 'webdrivers'

Webdrivers.install_dir = './webdrivers'

browser = 'chrome'
browser = ENV['BROWSER'] if ENV['BROWSER']

if browser.downcase == "chrome"
  current_driver = :selenium_chrome
elsif browser.downcase == "chrome_headless"
  Capybara.register_driver :selenium_chrome_headless do |app|
    arguments = ["headless","disable-gpu", "no-sandbox", "window-size=1920,1080", "privileged"]
    options = Selenium::WebDriver::Chrome::Options.new(args: arguments)
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  current_driver = :selenium_chrome_headless
elsif browser.downcase == "firefox"
  current_driver = :selenium
elsif browser.downcase == "firefox_headless"
  current_driver = :selenium_headless
else
  current_driver = :selenium_chrome
end

Capybara.run_server = false
Capybara.default_driver = current_driver
Capybara.javascript_driver = current_driver
Capybara.default_selector = :css
Capybara.default_max_wait_time = 5

Capybara.app_host = 'http://www.google.com'

World(Capybara::DSL)
puts "running on browser: #{browser}"