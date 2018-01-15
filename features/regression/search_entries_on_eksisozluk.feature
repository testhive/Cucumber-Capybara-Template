#encoding: UTF-8
Feature: Find entries on eksisozluk
  As a bored person
  I want to find some entries on eksisozluk
  In order to have some laughs

  Scenario: Search for an entry on eksisozluk
    Given I visit eksisozluk mainpage
    When I search for entry "türk astronot ve houston replikleri"
    Then I should see more than "30" pages of entries

  Scenario: View the first entry of todays highlights
    Given I visit eksisozluk mainpage
    When I go to first topic in highlights
    And List todays best entries for active topic
    Then The first entry should have todays date