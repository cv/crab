Feature: Pull From Rally Into Cucumber
  
  In order to begin development of a story that was written in Rally
  A developer who doesn't want to open a browser or click things
  Wants the story converted into the much nicer Cucumber format

  Background: 
    Given I am logged in

  Scenario: Pulling a Single Story
    Given a directory named "crab-pull"
    And I cd to "crab-pull"
    When I run `crab pull US4988`
    Then the output should contain "US4988: features/grooming/US4988-sample-crab-story.feature"
    And a directory named "features" should exist
    And a file named "features/grooming/US4988-sample-crab-story.feature" should exist
    And the file "features/grooming/US4988-sample-crab-story.feature" should contain exactly:
      """
      # language: en
      Feature: [US4988] Sample Crab Story

      Sample Description
      """

  Scenario: Pulling Multiple Stories
    When I run `crab pull US4988 US5000`
    Then the output should contain "US4988: features/grooming/US4988-sample-crab-story.feature"
    Then the output should contain "US5000: features/grooming/US5000-sample-crab-parent-story.feature"

