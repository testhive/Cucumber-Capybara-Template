Given(/^I visit akakce main page$/) do
  safe_visit 'http://www.akakce.com'
  expect(page).to have_selector('#q')
end

When(/^I search for a price with term "([^"]*)"$/) do |term|
  search_area = find_by_id('q')
  search_area.set term
  search_area.send_keys :enter
end

Then(/^Smallest price should be lesser than "([^"]*)" TRY$/) do |price|
  maximum_price = price.to_f
  find('a', text: "En düşük fiyatlılar").click
  smallest_price = find('.pt_v8', match: :first).text
  expect(maximum_price).to be > turkish_str_to_float(smallest_price)
end

When(/^I navigate to category "([^"]*)"$/) do |category_sequence|
  categories = category_sequence.split('>').map{|x| x.strip}
  expect(categories.size).to be > 0

  find('a', text: "Tüm Kategoriler").click
  categories.each {|cat| expect(page).to have_selector('a', text: /#{cat}/i)}
  find('a', text: /#{categories.last}/i, match: :first).click
end

Then(/^Highest price should be more than "([^"]*)" TRY$/) do |price|
  minimum_price = price.to_f
  find('a', text: "En yüksek fiyatlılar").click
  smallest_price = find('.pt_v8', match: :first).text
  expect(minimum_price).to be < turkish_str_to_float(smallest_price)
end