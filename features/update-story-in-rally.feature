Feature: Update Story in Rally

  In order to change a story's fields in Rally
  A developer who doesn't want to open a browser or click on things
  Wants to update those fields from the command line

  Background:
    Given I am logged in

  Scenario: Update Name
    When I run `crab story update US4988 --name "Sample Crab Story"`
    Then the output should contain "US4988: Sample Crab Story (grooming)"

  Scenario: Block and Unblock
    When I run `crab story update US4988 --blocked`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
    And the story US4988 should be blocked
    When I run `crab story update US4988 --unblocked`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
    And the story US4988 should be unblocked

  Scenario: Setting Parent
    When I run `crab story update US4988 --parent US5000`
    Then the story US4988 should have US5000 as its parent

