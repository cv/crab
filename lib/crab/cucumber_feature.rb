module Crab

  class CucumberFeature

    include Crab::Utilities

    def initialize(language)
      @language = Gherkin::I18n.new(language)
      @adapter = Crab::RallyToCucumberAdapter.new @language
    end

    def generate_from(story, include_testcases)
      text = StringIO.new
      formatter = Gherkin::Formatter::PrettyFormatter.new(text, true, false)
      feature = @adapter.feature_from story
      formatter.feature feature

      if include_testcases
        Array(story.test_cases).tap {|tcs| logger.info "#{tcs.size} test case(s) found" }.each do |test_case|
          formatter.scenario @adapter.scenario_from(test_case)
          test_case.steps.tap {|steps| logger.info "#{steps.size} step(s) found"}.each do |step|
            step_words = step.split(' ')
            comments = []
            keyword = step_words.shift
            name = " " + step_words.join(' ')
            line = 0

            formatter.step Gherkin::Formatter::Model::Step.new(comments, keyword, name, line)
          end
        end
      end

      formatter.eof

      text.string.strip
    end
  end
end
