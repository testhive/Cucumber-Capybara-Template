After do |scenario|
  if scenario.failed?
    tags = scenario.source_tag_names.map(&:downcase).map{|x| x.gsub('@','')}
    unless tags.include?("non-gui") || tags.include?("nongui")
      encoded_img = page.driver.browser.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png', "----- SCREENSHOT OF THE FAILURE -----")
    end
  end
end

at_exit do
  if ENV['security'] == 'true'
    require 'rspec'
    require 'fileutils'
    include RSpec::Matchers

    response = JSON.parse RestClient.get "#{$zap_proxy}:#{$zap_port}/json/core/view/alerts"
    events = response['alerts']

    high_risks = events.select{|x| x['risk'] == 'High'}
    high_count = high_risks.size
    medium_risks = events.select{|x| x['risk'] == 'Medium'}
    medium_count = medium_risks.size
    low_risks = events.select{|x| x['risk'] == 'Low'}
    low_count = low_risks.size
    informational_risks = events.select{|x| x['risk'] == 'Informational'}
    informational_count = informational_risks.size


    dir_path = File.expand_path(File.join(File.dirname(__FILE__), "../../build/security/"))
    if File.directory?(dir_path)
      Dir.foreach(dir_path) {|f| fn = File.join(dir_path, f); File.delete(fn) if f != '.' && f != '..'}
    end

    dir = File.dirname(dir_path)

    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end

    filename = "zap_report.json"
    report = File.new(dir_path + "/#{filename}", 'w')

    new_json = {
        high_alerts: high_risks,
        medium_alerts: medium_risks,
        low_alerts: low_risks,
        informational_alerts: informational_risks
    }.to_json

    report.puts new_json

    report.close

    p "Security report saved at: #{dir_path + "/#{filename}"}"
    if high_count > 0
      high_risks.each { |x| p x['alert'] }
    end

    expect(high_count).to eq 0
  end
end