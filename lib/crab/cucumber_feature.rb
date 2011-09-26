require 'fileutils'

module Crab

  class CucumberFeature
    def generate_from(story)
      return <<-FEATURE
Feature: [#{story.formatted_id}] #{story.name}

#{story.description}
FEATURE
    end
  end
end
