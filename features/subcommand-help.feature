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
      | Command         | Output                                                |
      | help            | Usage: crab <command> [options*]                      |
      | iteration       | Usage: crab iteration <command> [options*]            |
      | login           | Usage: crab login [options*]                          |
      | project         | Usage: crab project [name] [options*]                 |
      | release         | Usage: crab release <command> [options*]              |
      | story           | Usage: crab story <command> [options*]                |
      | testcase        | Usage: crab testcase <command> [options*]             |

      | story create    | Usage: crab story create <name> [options*]            |
      | story update    | Usage: crab story update <id> [options*]              |
      | story delete    | Usage: crab story delete <id> [options*]              |
      | story find      | Usage: crab story find [options*] [text]              |
      | story move      | Usage: crab story move <id> [options*]                |
      | story pull      | Usage: crab story pull <id> [id*] [options*]          |
      | story rename    | Usage: crab story rename <id> <name> [options*]       |
      | story show      | Usage: crab story show <id> [options*]                |
      | story help      | Usage: crab story <command> [options*]                |

      | testcase create | Usage: crab testcase create <story> <name> [options*] |
      | testcase update | Usage: crab testcase update <id> [options*]           |
      | testcase delete | Usage: crab testcase delete <id> [options*]           |
      | testcase find   | Usage: crab testcase find <story> [options*]          |
      | testcase show   | Usage: crab testcase show <id> [options*]             |
      | testcase help   | Usage: crab testcase <command> [options*]             |

      | release help    | Usage: crab release <command> [options*]              |
      | release list    | Usage: crab release list [options*]                   |

      | iteration help  | Usage: crab iteration <command> [options*]            |
      | iteration list  | Usage: crab iteration list [options*]                 |

