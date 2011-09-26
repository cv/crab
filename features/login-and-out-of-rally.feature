Feature: Log In and Out of Rally

  In order to avoid typing his credentials all the time
  A lazy and security-conscious developer
  Wants to log in and out of Rally in order to perform operations

  Scenario: Logged Out, Logging In
    Given I am logged out
    When I run `crab login` interactively
    # Then the output should contain "Username: "
    When I type my username
    # Then the output should contain "Password: "
    When I type my password
    Then the exit status should be 0

