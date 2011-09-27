Feature: Update Story in Rally
  
  In order to change a story's fields in Rally
  A developer who doesn't want to open a browser or click on things
  Wants to update those fields from the command line

  Background: 
    Given I am logged in

  Scenario: Update Name
    When I run `crab update US4988 --name "Sample Crab Story"`
    Then the output should contain "US4988: Sample Crab Story (grooming)"

  Scenario: Block and Unblock
    When I run `crab update US4988 --blocked`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
    And the story US4988 should be blocked
    When I run `crab update US4988 --unblocked`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
    And the story US4988 should be unblocked

  Scenario: Setting Iteration
    When I run `crab update US4988 --iteration "Iteration 0"`
    Then the story US4988 should be in iteration "Iteration 0"

  Scenario: Setting Release
    When I run `crab update US4988 --release "Beta release"`
    Then the story US4988 should be in release "Beta release"

  Scenario: Setting Parent
    When I run `crab update US4988 --parent US5000`
    Then the story US4988 should have US5000 as its parent

