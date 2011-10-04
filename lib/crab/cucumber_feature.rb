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
        Array(story.test_cases).tap {|tcs| logger.info "#{story.formatted_id}: #{tcs.size} test case(s) found" }.each do |test_case|
          formatter.scenario @adapter.scenario_from(test_case)
          @adapter.steps_from(test_case).each do |step|
            formatter.step step
          end
        end
      end

      formatter.eof

      text.string.strip
    end
  end
end
