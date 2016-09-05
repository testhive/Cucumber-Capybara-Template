Given(/^I visit google home page$/) do
	visit ''	
    find_by_id("lst-ib")
    sleep 3
end