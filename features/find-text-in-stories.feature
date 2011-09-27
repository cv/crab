Feature: Find Text in Stories

  In order to find the story ID
  A lazy developer
  Wants to search for arbitrary bits of text

  Background:
    Given I am logged in

  Scenario: Matching Name
    When I run `crab find --project "VEJA SP - Migração para o Alexandria" Sample Crab`
    Then the output should contain:
    """
US4988: Sample Crab Story (grooming)
US4999: Sample Crab Parent Story (grooming)
US5000: Sample Crab Parent Story (grooming)
    """

  @quick
  Scenario: Project Must be Specified
    When I run `crab find pattern`
    Then the output should contain "Error: argument --project must be specified."

  Scenario: Project Must Exist
    When I run `crab find --project "foo" pattern`
    Then the output should contain:
    """
    Error: Project "foo" not found.
    """
