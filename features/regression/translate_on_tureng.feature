#encoding: UTF-8
Feature: Translate on tureng
  As a student
  I want to be able to translate on tureng
  In order to not be embarrassed all the time

  Scenario: Translate from Turkish to English
    Given I visit tureng main page
    When I try to translate "şeker" from Turkish to English
    Then One of the translations should include "SuGaR"

  Scenario: translate from English to Turkish
    Given I visit tureng main page
    When I try to translate "comb" from Turkish to English
    Then One of the translations should include "tarak"