Feature: Recursively looks for .crab folder

  In order to easily work with multiple projects and avoid having to cd back into project's root
  A lazy developer
  Wants to run crab from any project's subfolder

  Background:
    Given I am logged in

  @quick
  Scenario: Uses Parent Folder Project Settings From Any Subfolder
    Given no project is selected
    And a directory named "crab-project/subfolder/othersubfolder"
    And I cd to "crab-project"
    And I have selected my test project
    When I cd to "subfolder"
    And I run `crab project`
    Then the output should be the name of my test project
    When I cd to "othersubfolder"
    And I run `crab project`
    Then the output should be the name of my test project
