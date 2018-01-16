#encoding: UTF-8
Feature: Make a search on Google
  As a user
  I want to be able to make a search on Google
  In order to find what i'm looking for

  Scenario: Visit google home page
    Given I visit google home page
    When I search for "michael jackson"
    Then I should see "Michael Jackson - Wikipedia" on search results

  Scenario: Search with no result
    Given I visit google home page
    When I search for "ajhasdfgjhsdafgguweryug23452324"
    Then There should be no results on page