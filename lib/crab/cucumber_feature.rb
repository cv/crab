require 'fileutils'

module Crab

  class CucumberFeature
    def generate_from(story)
      ::FileUtils.mkdir_p File.dirname(story.full_file_name)
      ::FileUtils.touch story.full_file_name

      File.open(story.full_file_name, "w") do |file|
        file.write <<-FEATURE
Feature: [#{story.formatted_id}] #{story.name}

#{story.description}
FEATURE
      end
    end
  end

end
