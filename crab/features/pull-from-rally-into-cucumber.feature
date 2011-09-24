Feature: Pull From Rally Into Cucumber

  In order to begin development of a story that was written in Rally
  A developer who doesn't want to open a browser or click things
  Wants the story converted into the much nicer Cucumber format

  Scenario: Pulling a Single Story
    Given an instance of Rally
    And a story with ID "US4479"
    When I run `crab pull US4479`
    Then the output should contain "US4479: features/US4479"

  Scenario: Pulling Multiple Stories
    Given an instance of Rally
    And a story with ID "US4479"
    And a story with ID "US4480"
    When I run `crab pull US4479 US4480`
    Then the output should contain "US4479: features/US4479"
    Then the output should contain "US4480: features/US4480"

