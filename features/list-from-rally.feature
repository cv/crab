Feature: List Stories in Rally

  In order to figure out which stories she needs to pull
  A developer who doesn't want to open a browser or click on things
  Wants to list stories in Rally

  @really-slow
  Scenario: Basic Invocation
    Given an instance of Rally
    And Rally has a story with ID "US4988"
    And I am logged in
    When I run `crab list -p "VEJA SP - Migração para o Alexandria"`
    Then the output should contain "US4988: Sample Crab Story (grooming)"

  @quick
  Scenario: Project Must be Specified
    When I run `crab list`
    Then the output should contain "Error: argument --project must be specified."
