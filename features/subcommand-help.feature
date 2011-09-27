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
    Then the output should contain "  find    Find stories by text in name, description or notes"
     And the output should contain "  login   Persistently authenticate user with Rally"
     And the output should contain "  project Persistently select project to work with in Rally"
     And the output should contain "  pull    Downloads stories (and its test cases) as Cucumber feature files"
     And the output should contain "  show    Show a story (and its test cases) as a Cucumber feature"
     And the output should contain "  update  Update a story (name, estimate, etc)"

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

  Scenario: Show Subcommand
    When I run `crab show --help`
    Then the output should contain:
    """
crab show: displays a story in Rally as a Cucumber feature

Usage: crab [options] show story
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

  Scenario: Find Subcommand
    When I run `crab find --help`
    Then the output should contain:
    """
crab find: find a story in Rally

Usage: crab [options] find [options] [text]
    """
