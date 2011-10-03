module Crab
  class CucumberScenario

    include Crab::Utilities

    def initialize(language)
      @language = Gherkin::I18n.new(language)
      @adapter = Crab::RallyToCucumberAdapter.new @language
    end

    def generate_from(test_case)
      text = StringIO.new
      formatter = Gherkin::Formatter::PrettyFormatter.new(text, true, false)

      formatter.scenario @adapter.scenario_from(test_case)
      @adapter.steps_from(test_case).each do |step|
        formatter.step step
      end
      formatter.eof

      text.string.strip
    end
  end
end
