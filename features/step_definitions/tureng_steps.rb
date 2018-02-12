Given(/^I visit tureng main page$/) do
  safe_visit 'http://www.tureng.com'
  expect(page).to have_selector('#searchTerm')
end

When(/^I try to translate "([^"]*)" from Turkish to English$/) do |turkish_term|
  search_area = find('.tureng-searchform')
  text_field = search_area.find_by_id('searchTerm')
  text_field.set turkish_term
  search_area.find('.btn-turengsearch').click
end

Then(/^One of the translations should include "([^"]*)"$/) do |translation|
  translations = find_by_id('englishResultsTable', match: :first)
  expect(translations).to have_text /#{translation}/i
end