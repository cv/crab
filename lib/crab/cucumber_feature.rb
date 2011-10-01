module Crab

  class CucumberFeature

    def initialize(language)
      @language = Gherkin::I18n.new(language)
    end

    def generate_from(story, include_testcases)
      text = <<-FEATURE
# language: #{@language.iso_code}
#{@language.keywords('feature').last}: [#{story.formatted_id}] #{story.name}

#{story.description}
      FEATURE

      if include_testcases
        text << <<-SCENARIOS
#{Array(story.scenarios).map {|scenario| CucumberScenario.new(@language.iso_code).generate_from scenario }}
        SCENARIOS
      end

      text.strip
    end
  end
end
