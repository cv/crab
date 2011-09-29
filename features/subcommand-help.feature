@quick
Feature: Subcommand Help

  In order to learn how to use crab
  A newbie developer
  Wants to see a useful help message when she runs crab with the wrong arguments

  Scenario: No Arguments
    When I run `crab`
    Then I should see a usage screen

  Scenario: Bogus Subcommand
    When I run `crab bogus`
    Then I should see a usage screen

  Scenario Outline: Subcommands And Help Text
    When I run `crab <Command> --help`
    Then the output should contain "<Output>"

    Examples:
      | Command         | Output                                             |
      | help            | Usage: crab <command> [options*]                   |
      | create          | Usage: crab create <name> [options*]               |
      | delete          | Usage: crab delete <story> [options*]              |
      | find            | Usage: crab find [text] [options*]                 |
      | login           | Usage: crab login [options*]                       |
      | move            | Usage: crab move <story> [options*]                |
      | project         | Usage: crab project [name] [options*]              |
      | pull            | Usage: crab pull <story1> [story2 ...] [options*]  |
      | rename          | Usage: crab rename <story> <new name> [options*]   |
      | show            | Usage: crab show <story> [options*]                |
      | testcase        | Usage: crab testcase <command> [options*]          |
      | testcase add    | Usage: crab testcase add <story> <name> [options*] |
      | testcase delete | Usage: crab testcase delete <story> [options*]     |
      | testcase list   | Usage: crab testcase list <story> [options*]       |
      | testcase show   | Usage: crab testcase show <testcase> [options*]    |
      | testcase update | Usage: crab testcase update <testcase> [options*]  |
      | update          | Usage: crab update <story> [options*]              |

