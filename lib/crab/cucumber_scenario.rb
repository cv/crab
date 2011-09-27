module Crab
  class CucumberScenario

    def initialize(language)
      @language = Gherkin::I18n.new(language)
    end

    def generate_from(scenario)
      tags = [scenario.method, scenario.test_type]
      return <<-SCENARIO

#{tags.map {|t| " @" + t.strip }.join}
#{@language.keywords('scenario').last}: [#{scenario.formatted_id}] #{scenario.name}
  #{scenario.steps.join("\n  ")}
      SCENARIO
    end
  end
end
