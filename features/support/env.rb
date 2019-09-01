#encoding: UTF-8
require 'cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'rest-client'
require 'pdf-reader'

if ENV['docker_run'] != "true"
  if (/darwin/ =~ RUBY_PLATFORM) != nil
    Selenium::WebDriver::Chrome.driver_path = "webdriver_binaries/macosx/chromedriver"
    Selenium::WebDriver::Firefox.driver_path = "webdriver_binaries/macosx/geckodriver"
  elsif (/mingw/ =~ RUBY_PLATFORM) != nil
    Selenium::WebDriver::Chrome.driver_path = "webdriver_binaries/windows/chromedriver.exe"
    Selenium::WebDriver::Firefox.driver_path = "webdriver_binaries/windows/geckodriver.exe"
    Selenium::WebDriver::IE.driver_path = "webdriver_binaries/windows/IEDriverServer.exe"
  else
    Selenium::WebDriver::Chrome.driver_path = "webdriver_binaries/linux/chromedriver"
    Selenium::WebDriver::Firefox.driver_path = "webdriver_binaries/linux/geckodriver"
  end

end

browser = ENV['BROWSER']
Capybara.register_driver :selenium do |app|
  browser = ENV['BROWSER']
  if browser == "firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
  elsif browser == "headless-firefox"
    ENV['MOZ_HEADLESS'] = '1'
    profile = Selenium::WebDriver::Firefox::Profile.new
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
  elsif browser == "headless-chrome"
    arguments = ["headless","disable-gpu", "no-sandbox", "window-size=1920,1080", "privileged"]
    preferences = {
        'download.default_directory': File.expand_path(File.join(File.dirname(__FILE__), "../../downloads/")),
        'download.prompt_for_download': false,
        'plugins.plugins_disabled': ["Chrome PDF Viewer"],
    }
    options = Selenium::WebDriver::Chrome::Options.new(args: arguments, prefs: preferences)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  else
    arguments = ["start-maximized"]
    preferences = {
        'download.default_directory': File.expand_path(File.join(File.dirname(__FILE__), "../../downloads/")),
        'download.prompt_for_download': false,
        'plugins.plugins_disabled': ["Chrome PDF Viewer"]
    }
    options = Selenium::WebDriver::Chrome::Options.new(args: arguments, prefs: preferences)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end

if ENV['security'] == 'true'
  Capybara.register_driver :selenium do |app|
    $zap_proxy = ENV['zap_proxy']
    $zap_port = ENV['zap_port']
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["network.http.phishy-userpass-length"] = "255"
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(proxy: Selenium::WebDriver::Proxy.new(http: "#{$zap_proxy}:#{$zap_port}"))

    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, desired_capabilities: caps)
  end
end

Capybara.run_server = false
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_selector = :css
Capybara.default_max_wait_time = 10

Capybara.app_host = 'http://www.google.com'

World(Capybara::DSL)
puts "running on browser: #{browser}"