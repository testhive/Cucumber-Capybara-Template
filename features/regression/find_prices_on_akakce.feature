#encoding: UTF-8
Feature: Price search on Akakce
  As a customer
  I want to find the best price for my item
  In order to be a smart shopper

  Scenario: Use product search to find price
    Given I visit akakce main page
    When I search for a price with term "mancoloji"
    Then Smallest price should be lesser than "100" TRY

  Scenario: Select a product category to see prices
    Given I visit akakce main page
    When I navigate to category "Elektronik > Cep telefonu"
    Then Highest price should be more than "6500" TRY