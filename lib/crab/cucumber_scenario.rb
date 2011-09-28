module Crab
  class CucumberScenario

    def initialize(language)
      @language = Gherkin::I18n.new(language)
    end

    def generate_from(scenario)
      return <<-SCENARIO

#{scenario.tags.map {|tag| "@" + tag }.join(" ")}
#{@language.keywords('scenario').last}: [#{scenario.formatted_id}] #{scenario.name}
  #{scenario.steps.join("\n  ")}
      SCENARIO
    end
  end
end
