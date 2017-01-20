Given(/^I visit google home page$/) do
	visit ''	
  find_by_id("lst-ib")
  5.should eq 4
end

Given(/^I get a response from swagger$/) do
  resp = RestClient.get "http://petstore.swagger.io/v2/pet/findByStatus?status=very-available"
  p resp.code
  p JSON.parse(resp)
  4.should eq 6
end