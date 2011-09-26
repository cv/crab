Feature: Update Story in Rally

  In order to change a story's fields in Rally
  A developer who doesn't want to open a browser or click on things
  Wants to update those fields from the command line

  Scenario: Update Name
    Given an instance of Rally
    And Rally has a story with ID "US4988"
    And I am logged in
    When I run `crab update US4988 --name "Sample Crab Story"`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
