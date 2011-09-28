module Crab::Commands

  class Pull

    def initialize(args)
      @story_numbers = args

      @cmd_opts = Trollop::options do
        banner "crab pull: pulls stories from Rally and writes them out as Cucumber features

Usage: crab pull [options] story1 [story2 ...]"
        opt :language, "Language to generate Cucumber features in (ISO code)", :default => "en", :short => "-l"
      end

      @rally = Crab::Rally.new
    end

    def run
      @rally.connect

      @story_numbers.each do |story_number|
        story = @rally.find_story_with_id story_number
        Trollop::die "Could not find story with ID #{story_number}" if story.nil?

        puts "#{story.formatted_id}: #{story.full_file_name}"

        FileUtils.mkdir_p File.dirname(story.full_file_name)
        FileUtils.touch story.full_file_name

        File.open(story.full_file_name, "w") do |file|
          file.write Crab::CucumberFeature.new(@cmd_opts[:language]).generate_from story
        end
      end
    end
  end
end
