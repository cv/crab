Feature: Pull From Rally Into Cucumber

  In order to begin development of a story that was written in Rally
  A developer who doesn't want to open a browser or click things
  Wants the story converted into the much nicer Cucumber format

  Scenario: Pulling a Single Story
    Given an instance of Rally
    And Rally has a story with ID "US4479"
    And I am logged in
    And a directory named "crab-pull"
    And I cd to "crab-pull"
    When I run `crab pull US4479`
    Then the output should contain "US4479: features/US4479"
    And a directory named "features" should exist
    And a file named "features/US4479-criar-e-ver-estabelecimento-com-informacoes-basicas.feature" should exist

  Scenario: Pulling Multiple Stories
    Given an instance of Rally
    And Rally has a story with ID "US4479"
    And Rally has a story with ID "US4480"
    And I am logged in
    When I run `crab pull US4479 US4480`
    Then the output should contain "US4479: features/US4479"
    Then the output should contain "US4480: features/US4480"

