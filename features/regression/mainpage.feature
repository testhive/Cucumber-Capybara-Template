#encoding: UTF-8
Feature: Make a search on Google
  As a user
  I want to be able to make a search on Google
  In order to find what i'm looking for

  Scenario: Visit google home page
    Given I visit google home page

  @non-gui
  Scenario: I hit a service
    Given I get a response from swagger