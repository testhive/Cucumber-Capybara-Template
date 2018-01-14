Given(/^I visit google home page$/) do
	visit ''	
  find_by_id("lst-ib")
end

Given(/^I get a response from swagger$/) do
  resp = RestClient.get "http://petstore.swagger.io/v2/pet/findByStatus?status=very-available"
  p resp.code
  p JSON.parse(resp)
end

Given(/^I perform operations on petstore$/) do
  url = "http://petstore.swagger.io/v2/pet"
  pet_id = Time.now.to_i
  pet_body = {
      "id": pet_id,
      "category": {
          "id": Time.now.to_i,
          "name": "category-test"
      },
      "name": "test pet",
      "photoUrls": [
          "string"
      ],
      "tags": [
          {
              "id": Time.now.to_i,
              "name": "tag-name"
          }
      ],
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