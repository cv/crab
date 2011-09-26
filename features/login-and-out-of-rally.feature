Feature: Log In and Out of Rally

  In order to avoid typing his credentials all the time
  A lazy and security-conscious developer
  Wants to log in and out of Rally in order to perform operations

  Scenario: Logged Out, Logging In
    Given I am logged out
    When I run `crab login` interactively
    And I type my username
    And I type my password
    Then the exit status should be 0
    And a file named ".rally_credentials" in the user's home directory should exist

