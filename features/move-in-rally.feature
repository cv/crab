Feature: Move in Rally

  In order to update a story status without the hassle of figuring out 'crab update'
  An incredibly lazy develper
  Wants to use a simple command to move a story to the next available state

  Background:
    Given I am logged in

  Scenario: Move Then Go Back
    When I run `crab move US4988`
    Then the output should contain "US4988: Sample Crab Story (defined)"

    When I run `crab move US4988 --back`
    Then the output should contain "US4988: Sample Crab Story (grooming)"
