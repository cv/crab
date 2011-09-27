Feature: Project Selection

  In order to work with the find, list etc commands more effectively
  A lazy developer
  Wants to set the project persistently across all commands

  Scenario: Selecting a Project
    Given no project is selected
    When I run `crab project`
    Then the output should contain "No project currently selected."
    When I run `crab project "VEJA SP - Migração para o Alexandria"`
    Then the exit status should be 0
    When I run `crab project`
    Then the output should contain "VEJA SP - Migração para o Alexandria"

  Scenario: Selecting an Invalid Project
    When I run `crab project "invalid"`
    Then the output should contain:
    """
    Error: "invalid" is not a valid project.
    """
