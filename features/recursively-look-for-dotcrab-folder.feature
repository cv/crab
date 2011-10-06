Feature: Recursively looks for .crab folder

  In order to easily work with multiple projects and avoid having to cd back into project's root
  A lazy developer
  Wants to run crab from any project's subfolder

  Background:
    Given a directory named "crab-project/subfolder/othersubfolder"

  Scenario: Uses Parent Folder Project Settings From Any Subfolder
    Given I am logged in
    And no project is selected
    And I cd to "crab-project"
    And I have selected my test project
    When I cd to "subfolder"
    And I run `crab project`
    Then the output should be the name of my test project
    When I cd to "othersubfolder"
    And I run `crab project`
    Then the output should be the name of my test project

  Scenario: Uses Parent Folder Credentials From Subfolder
    Given I run `crab logout`
    And I cd to "crab-project"
    When I run `crab login -P` interactively
    And I type my username
    And I type my password
    Then a file named ".crab/credentials" should exist
    When I cd to "subfolder"
    And I run `crab logout`
    Then a file named "../.crab/credentials" should not exist
