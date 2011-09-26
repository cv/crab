Feature: Empty Subcommand Help

  In order to learn how to use crab
  A newbie developer
  Wants to see a useful help message when she runs crab without arguments

  Scenario: No Arguments
    When I run `crab`
    Then the output should contain:
    """
Error: Unknown subcommand.
Try --help for help.
    """
