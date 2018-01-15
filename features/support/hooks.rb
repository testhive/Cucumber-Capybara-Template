After do |scenario|
  if scenario.failed?
    tags = scenario.source_tag_names.map(&:downcase).map{|x| x.gsub('@','')}
    unless tags.include?("non-gui") || tags.include?("nongui")
      encoded_img = page.driver.browser.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png', "----- SCREENSHOT OF THE FAILURE -----")
    end
  end
end

# Before do
#   if ENV['BROWSER'] == "headless-firefox" || ENV['BROWSER'] == "firefox"
#     page.driver.browser.manage.window.resize_to(1440,900)
#   end
# end

at_exit do
  require 'rspec'
  include RSpec::Matchers

  if ENV['security'] == 'true'
    response = JSON.parse RestClient.get "#{$zap_proxy}:#{$zap_port}/json/core/view/alerts"
    events = response['alerts']
    events.each { |x| p x }
    high_risks = events.select{|x| x['risk'] == 'High'}
    high_count = high_risks.size
    medium_count = events.select{|x| x['risk'] == 'Medium'}.size
    low_count = events.select{|x| x['risk'] == 'Low'}.size
    informational_count = events.select{|x| x['risk'] == 'Informational'}.size

    if high_count > 0
      high_risks.each { |x| p x['alert'] }
    end

    expect(high_count).to eq 0
  end
end