Feature: Project Selection
  
  In order to work with the find, list etc commands more effectively
  A lazy developer
  Wants to set the project persistently across all commands

  Background: 
    Given I am logged in

  Scenario: Selecting a Project
    Given no project is selected
    When I run `crab project`
    Then the output should contain "No project currently selected."
    When I select my test project
    Then the exit status should be 0
    When I run `crab project`
    Then the output should be the name of my test project

  Scenario: Selecting an Invalid Project
    When I run `crab project "invalid"`
    Then the output should contain:
      """
      Error: "invalid" is not a valid project.
      """

