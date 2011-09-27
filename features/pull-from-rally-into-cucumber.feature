Feature: Pull From Rally Into Cucumber

  In order to begin development of a story that was written in Rally
  A developer who doesn't want to open a browser or click things
  Wants the story converted into the much nicer Cucumber format

  Scenario: Pulling a Single Story
    Given an instance of Rally
    And Rally has a story with ID "US4988"
    And I am logged in
    And a directory named "crab-pull"
    And I cd to "crab-pull"
    When I run `crab pull US4988`
    Then the output should contain "US4988: features/grooming/US4988-sample-crab-story.feature"
    And a directory named "features" should exist
    And a file named "features/grooming/US4988-sample-crab-story.feature" should exist
    And the file "features/grooming/US4988-sample-crab-story.feature" should contain exactly:
    """
Feature: [US4988] Sample Crab Story

Sample Description
    """

  Scenario: Pulling Multiple Stories
    Given an instance of Rally
    And Rally has a story with ID "US4988"
    And Rally has a story with ID "US5000"
    And I am logged in
    When I run `crab pull US4988 US5000`
    Then the output should contain "US4988: features/grooming/US4988"
    Then the output should contain "US5000: features/grooming/US5000"

