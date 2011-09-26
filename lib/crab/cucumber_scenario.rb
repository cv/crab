module Crab
  class CucumberScenario
    def generate_from(scenario)
      return <<-SCENARIO

Scenario: [#{scenario.formatted_id}] #{scenario.name}
  #{scenario.steps.join("\n  ")}
      SCENARIO
    end
  end
end
