Feature: Show Story From Rally

  In order to see what's in a story
  A lazy developer
  Wants to be able to do it from the command line

  Background:
    Given I am logged in

  Scenario: Show Simple Story
    When I run `crab show US4988`
    Then the output should contain:
      """
      Feature: [US4988] Sample Crab Story

      Sample Description
      """

  Scenario: Show Story With Test Cases
    When I run `crab show US5000`
    Then the output should contain "Feature: [US5000] Sample Crab Parent Story"
    And the output should contain "@important @medium @manual @acceptance"
    And the output should contain "Scenario: [TC10388] Sample Testcase"
    And the output should contain "  Given Rally behaves"
    And the output should contain "  When I look at the test case steps"
    And the output should contain "  Then I should be able to export them into Cucumber format"

  Scenario: Story In Different Language
    When I run `crab show US5000 --language pt`
    Then the output should contain "Funcionalidade: "
    And the output should contain "Cenario: "

