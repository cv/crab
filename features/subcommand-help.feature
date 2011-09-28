@quick
Feature: Subcommand Help

  In order to learn how to use crab
  A newbie developer
  Wants to see a useful help message when she runs crab with the wrong arguments

  Scenario: No Arguments
    When I run `crab`
    Then the output should contain "Error: Unknown subcommand."

  Scenario: Help
    When I run `crab -h`
    Then the output should contain "create  Create a new story in Rally"
    And the output should contain "delete  Delete an existing story in Rally"
    And the output should contain "find  Find stories by text in name, description or notes"
    And the output should contain "login  Persistently authenticate user with Rally"
    And the output should contain "move  Move a story from one status to the next (or previous)"
    And the output should contain "project  Persistently select project to work with in Rally"
    And the output should contain "pull  Downloads stories (and its test cases) as Cucumber feature files"
    And the output should contain "show  Show a story (and its test cases) as a Cucumber feature"
    And the output should contain "testcase  Manage test cases in a story (add, update, delete)"
    And the output should contain "update  Update a story (name, estimate, etc)"

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

      Usage: crab pull [options] story1 [story2 ...]
      """

  Scenario: Show Subcommand
    When I run `crab show --help`
    Then the output should contain:
      """
      crab show: displays a story in Rally as a Cucumber feature

      Usage: crab show story
      """

  Scenario: Create Subcommand
    When I run `crab create --help`
    Then the output should contain:
      """
      crab create: create a new story in Rally

      Usage: crab create name [options]
      """

  Scenario: Delete Subcommand
    When I run `crab delete --help`
    Then the output should contain:
      """
      crab delete: delete an existing story in Rally

      Usage: crab delete story [options]
      """

  Scenario: Testcase Subcommand
    When I run `crab testcase --help`
    Then the output should contain "crab testcase: manage test cases in a story (add, update, delete)"
    And the output should contain "Usage: crab testcase add story name [options]"
    And the output should contain "crab testcase update testcase [options]"
    And the output should contain "crab testcase delete testcase [options]"

  Scenario: Update Subcommand
    When I run `crab update --help`
    Then the output should contain:
      """
      crab update: update a story in Rally

      Usage: crab update story [options]
      """

  Scenario: Update Needs a Story Number
    When I run `crab update`
    Then the output should contain "Error: No story given."

  Scenario: Update Needs At Least One Switch
    When I run `crab update US4988`
    Then the output should contain "Error: Nothing to update. Please provide some options."

  Scenario: Find Subcommand
    When I run `crab find --help`
    Then the output should contain:
      """
      crab find: find a story in Rally

      Usage: crab find [options] [text]
      """

  Scenario: Move Subcommand
    When I run `crab move --help`
    Then the output should contain:
      """
      crab move: move a story from one status to the next (or previous)

      Usage: crab move story [options]
      """

