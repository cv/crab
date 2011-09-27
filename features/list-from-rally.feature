Feature: List Stories in Rally

  In order to figure out which stories she needs to pull
  A developer who doesn't want to open a browser or click on things
  Wants to list stories in Rally

  Background:
    Given I am logged in
    And I have selected the project "VEJA SP - Migração para o Alexandria"

  @really-slow
  Scenario: Basic Invocation
    When I run `crab list`
    Then the output should contain "US4988: Sample Crab Story (grooming)"

  @quick
  Scenario: Project Must be Specified When Not Selected
    Given no project is selected
    When I run `crab list`
    Then the output should contain "Error: argument --project must be specified."

  Scenario: Project Must Exist
    When I run `crab list -p "foo"`
    Then the output should contain:
    """
    Error: Project "foo" not found.
    """
