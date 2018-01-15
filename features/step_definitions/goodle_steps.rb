Given(/^I visit google home page$/) do
	visit ''	
  expect(page).to have_selector("#lst-ib")
end

When(/^I search for "([^"]*)"$/) do |search_term|
  search_field = find_by_id('lst-ib')
  search_field.set search_term
  search_field.send_keys :enter
end

Then(/^I should see "([^"]*)" on search results$/) do |result_header_text|
  expect(page).to have_selector(".rc > h3", text: result_header_text)
end

Then(/^There should be no results on page$/) do
  expect(page).to have_selector(".mnr-c")
end