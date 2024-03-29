#encoding: UTF-8
Feature: Make a search on Wikipedia
  As a user
  I want to be able to make a search on Wikipedia
  In order to gain more knowledge

  Scenario: Search Michael on Wiki
    Given I visit wiki home page
    When I search for "michael jackson"
    Then I should see page title "Michael Jackson"

  Scenario: Search with no result
    Given I visit wiki home page
    When I search for "ajhasdfgjhsdafgguweryug23452324"
    Then There should be no results on page