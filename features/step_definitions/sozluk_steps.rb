Given(/^I visit eksisozluk mainpage$/) do
  visit 'http://www.eksisozluk.com'
  expect(page).to have_selector('#search-textbox')
end

When(/^I search for entry "([^"]*)"$/) do |title|
  search_field = find_by_id('search-textbox')
  search_field.set title
  search_field.send_keys :enter
end

Then(/^I should see more than "([^"]*)" pages of entries$/) do |page_count|
  count = page_count.to_i
  pager = find('.sub-title-container').find('.pager')
  expect(pager['data-pagecount'].to_i).to be > count
end

When(/^I go to first topic in highlights$/) do
  find('.topic-list').find('li', match: :first).click
end

And(/^List todays best entries for active topic$/) do
  find_by_id('content-body').find("a[href*='dailynice']").click
end

Then(/^The first entry should have todays date$/) do
  date = find_by_id('entry-list').find('li', match: :first).find('.entry-date').text
  current_date = Date.today.strftime("%d.%m.%Y")
  expect(date).to include current_date
end