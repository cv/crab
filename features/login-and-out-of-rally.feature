Feature: Log In and Out of Rally

  In order to avoid typing his credentials all the time
  A lazy and security-conscious developer
  Wants to log in and out of Rally in order to perform operations

  Scenario: Logged Out, Logging In
    When I run `crab login` interactively
    And I type my username
    And I type my password
    Then the exit status should be 0
    And the user's home directory should have a file named ".crab/credentials"

  Scenario: Logged Out, Logging In project specific
    Given a directory named "my-project"
    And I cd to "my-project"
    When I run `crab login -P` interactively
    And I type my username
    And I type my password
    Then the exit status should be 0
    And a file named ".crab/credentials" should exist
