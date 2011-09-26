require 'fileutils'

module Crab

  class CucumberFeature
    def generate_from(story)
      return <<-FEATURE
Feature: [#{story.formatted_id}] #{story.name}

#{story.description}

#{Array(story.scenarios).map {|scenario| CucumberScenario.new.generate_from scenario }}
FEATURE
    end
  end
end
