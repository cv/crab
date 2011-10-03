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
      test_case.steps.tap {|steps| logger.info "#{steps.size} step(s) found"}.each do |step|
        step_words = step.split(' ')
        comments = []
        keyword = step_words.shift
        name = " " + step_words.join(' ')
        line = 0

        formatter.step Gherkin::Formatter::Model::Step.new(comments, keyword, name, line)
      end
      formatter.eof

      text.string.strip
    end
  end
end
