require 'active_support/all'

module Crab

  class Pull

    def initialize(global_options, pull_options, story_numbers)
      @global_options = global_options
      @pull_options = pull_options
      @story_numbers = story_numbers
      @rally = Crab::Rally.new
    end

    def run
      @rally.connect

      @story_numbers.each do |story_number|
        story = @rally.find_story_with_id story_number
        Trollop::die "Could not find story with ID #{story_number}" if story.nil?

        puts "#{story.formatted_id}: #{story.full_file_name}"

        CucumberFeature.new.generate_from story
      end
    end
  end
end
