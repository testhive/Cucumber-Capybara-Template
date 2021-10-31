@non-gui
Feature: Pet creation Journey on petstore
  As a petstore user
  I want to be able to maintain pets via API
  In order to perform my operations faster

  Scenario: Create new pet
    Given I create a new pet with these details
    | id         | name  | category | status |
    | 1155227733 | doggy | dog      | alive  |
    When I query the pet with id "1155227733" successfully
    Then I delete the pet with id "1155227733"
