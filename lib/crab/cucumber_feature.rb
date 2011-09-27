module Crab

  class CucumberFeature

    def initialize(language)
      @language = Gherkin::I18n.new(language)
    end

    def generate_from(story)
      text = <<-FEATURE
# language: #{@language.iso_code}
#{@language.keywords('feature').last}: [#{story.formatted_id}] #{story.name}

#{story.description}

#{Array(story.scenarios).map {|scenario| CucumberScenario.new(@language.iso_code).generate_from scenario }}
FEATURE
      text.strip
    end
  end
end
