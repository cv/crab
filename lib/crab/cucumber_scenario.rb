module Crab
  class CucumberScenario
    def generate_from(scenario)
      tags = [scenario.method, scenario.test_type]
      return <<-SCENARIO

#{tags.map {|t| " @" + t.strip }.join}
Scenario: [#{scenario.formatted_id}] #{scenario.name}
  #{scenario.steps.join("\n  ")}
      SCENARIO
    end
  end
end
