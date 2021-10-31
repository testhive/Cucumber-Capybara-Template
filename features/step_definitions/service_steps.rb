Given(/^I get a response from swagger$/) do
  resp = RestClient.get "http://petstore.swagger.io/v2/pet/findByStatus?status=very-available"
  p resp.code
  p JSON.parse(resp)
end

Given(/^I perform operations on petstore for gatling$/) do
  url = "http://petstore.swagger.io/v2/pet"
  pet_id = Time.now.to_i
  pet_body = {
      "id": pet_id,
      "category": {"id": Time.now.to_i, "name": "category-test"},
      "name": "test pet",
      "photoUrls": ["string"],
      "tags": [{"id": Time.now.to_i, "name": "tag-name"}],
      "status": "available"
  }

  RestClient.proxy = "http://localhost:8000"

  begin
    RestClient::Request.execute(method: :delete,
                                url: url + "/#{pet_id}",
                                headers: {"accept": "application/xml"},
                                :verify_ssl => OpenSSL::SSL::VERIFY_NONE)
    p "Pet with id: #{pet_id} deleted on petstore, continuing operation"
  rescue RestClient::NotFound => e
    p "Pet with id: #{pet_id} not found on petstore, continuing operation"
  end

  response = RestClient::Request.execute(method: :post,
                                         url: url,
                                         payload: pet_body.to_json,
                                         headers: {"Content-Type": "application/json"},
                                         :verify_ssl => OpenSSL::SSL::VERIFY_NONE)
  expect(response.code).to eq 200

  response = RestClient::Request.execute(method: :delete,
                                         url: url + "/#{pet_id}",
                                         headers: {"accept": "application/xml"},
                                         :verify_ssl => OpenSSL::SSL::VERIFY_NONE)
  expect(response.code).to eq 200

  begin
    RestClient::Request.execute(method: :get,
                                url: url + "/#{pet_id}",
                                headers: {"accept": "application/xml"},
                                :verify_ssl => OpenSSL::SSL::VERIFY_NONE)
  rescue RestClient::NotFound => e
    expect(e.response.code).to eq 404
  end
end

Given(/^I make sure there is no pet with id "([^"]*)"$/) do |pet_id|
  url = "https://petstore.swagger.io/v2/pet"
  begin
    RestClient::Request.execute(method: :delete,
                                url: url + "/#{pet_id}",
                                headers: {"accept": "application/json"})
    p "Pet with id: #{pet_id} deleted on petstore, continuing operation"
  rescue RestClient::NotFound => e
    p "Pet with id: #{pet_id} not found on petstore, continuing operation"
  end
  sleep 3
end

When(/^I create a new pet with these details$/) do |table|
  # table is a table.hashes.keys # => [:id, :name, :category, :status]
  url = "https://petstore.swagger.io/v2/pet"
  values = table.hashes.first
  pet_body = {
    "id": values['id'],
    "category": {"id": Time.now.to_i, "name": values['category']},
    "name": values['name'],
    "photoUrls": ["string"],
    "tags": [{"id": Time.now.to_i, "name": "tag-name"}],
    "status": values['status']
  }

  response = RestClient::Request.execute(method: :post,
                                         url: url,
                                         payload: pet_body.to_json,
                                         headers: {"Content-Type": "application/json"})
  expect(response.code).to eq 200
  sleep 3
end

And(/^I query the pet with id "([^"]*)" successfully$/) do |pet_id|
  url = "https://petstore.swagger.io/v2/pet"
  response = RestClient::Request.execute(method: :get,
                             url: url + "/#{pet_id}")

  expect(response.code).to eq 200
end

Then(/^I delete the pet with id "([^"]*)"$/) do |pet_id|
  url = "https://petstore.swagger.io/v2/pet"

  response = RestClient::Request.execute(method: :delete,
                                         url: url + "/#{pet_id}")
  expect(response.code).to eq 200
end