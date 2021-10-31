Given(/^I visit wiki home page$/) do
  safe_visit "https://en.wikipedia.org/wiki/Main_Page"
end

When(/^I search for "([^"]*)"$/) do |term|
  find_by_id("searchInput").set term
  find_by_id("searchButton").click
end

Then(/^I should see page title "([^"]*)"$/) do |title|
  expect(find_by_id("firstHeading").text.downcase).to eq title.downcase
end

Then(/^There should be no results on page$/) do
  expect(page).to have_selector ".mw-search-nonefound"
end