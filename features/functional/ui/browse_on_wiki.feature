#encoding: UTF-8
Feature: Browse categories on Wikipedia
  As a user
  I want to be able browse categories on Wiki
  In order to gain more knowledge

  Scenario: Go to science section
    Given I visit wiki home page
    When I browse to "History" section
    Then I should see "History" page title
