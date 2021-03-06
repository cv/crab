Feature: Find Text in Stories

  In order to find the story ID
  A lazy developer
  Wants to search for arbitrary bits of text

  Background:
    Given I am logged in
    And I have selected my test project

  Scenario: Matching Name
    When I run `crab story find Sample Crab`
    Then the output should contain:
      """
      US4988: Sample Crab Story (grooming)
      US5000: Sample Crab Parent Story (grooming)
      """

  @quick
  Scenario: Project Must be Specified If Not Set
    Given no project is selected
    When I run `crab story find pattern`
    Then the output should contain "Error: argument --project must be specified."

  Scenario: Project Must Exist
    When I run `crab story find --project "foo" pattern`
    Then the output should contain:
      """
      Error: Project "foo" not found.
      """

