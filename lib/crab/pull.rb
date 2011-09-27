require 'active_support/all'

module Crab

  class Pull

    def initialize(global_opts, cmd_opts, story_numbers)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @story_numbers = story_numbers
      @rally = Crab::Rally.new
    end

    def run
      @rally.connect

      @story_numbers.each do |story_number|
        story = @rally.find_story_with_id story_number
        Trollop::die "Could not find story with ID #{story_number}" if story.nil?

        puts "#{story.formatted_id}: #{story.full_file_name}"

        ::FileUtils.mkdir_p File.dirname(story.full_file_name)
        ::FileUtils.touch story.full_file_name

        File.open(story.full_file_name, "w") do |file|
          file.write CucumberFeature.new(@cmd_opts[:language]).generate_from story
        end
      end
    end
  end
end
