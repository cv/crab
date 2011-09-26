@quick
Feature: Subcommand Help

  In order to learn how to use crab
  A newbie developer
  Wants to see a useful help message when she runs crab with the wrong arguments

  Scenario: No Arguments
    When I run `crab`
    Then the output should contain "Error: Unknown subcommand."

  Scenario: Bogus Subcommand
    When I run `crab bogus`
    Then the output should contain:
    """
Error: Unknown subcommand "bogus".
    """

  Scenario: Pull Subcommand
    When I run `crab pull --help`
    Then the output should contain:
    """
crab pull: pulls stories from Rally and writes them out as Cucumber features

Usage: crab [options] pull story1 [story2 ...]
    """

  Scenario: List Subcommand
    When I run `crab list --help`
    Then the output should contain:
    """
crab list: lists stories in Rally

Usage: crab [options] list
    """

  Scenario: Update Subcommand
    When I run `crab update --help`
    Then the output should contain:
    """
crab update: update a story in Rally

Usage: crab [options] update story [options]
    """

  Scenario: Update Needs a Story Number
    When I run `crab update`
    Then the output should contain "Error: No story given."

  Scenario: Update Needs At Least One Switch
    When I run `crab update US4988`
    Then the output should contain "Error: Nothing to update. Please provide some options."

