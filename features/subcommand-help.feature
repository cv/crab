Feature: Subcommand Help

  In order to learn how to use crab
  A newbie developer
  Wants to see a useful help message when she runs crab with the wrong arguments

  Scenario: No Arguments
    When I run `crab`
    Then the output should contain:
    """
Error: Unknown subcommand.
Try --help for help.
    """

  Scenario: Bogus Subcommand
    When I run `crab bogus`
    Then the output should contain:
    """
Error: Unknown subcommand "bogus".
Try --help for help.
    """
