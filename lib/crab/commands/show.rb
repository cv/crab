module Crab::Commands

  class Show
    def initialize(global_opts, args)
      @global_opts = global_opts
      @cmd_opts = Trollop::options do
        banner "crab show: displays a story in Rally as a Cucumber feature

Usage: crab [options] show story"
        opt :language, "Language to display Cucumber features in (ISO code)", :default => "en", :short => "-l"
      end

      @story_id = args.first
      @rally = Crab::Rally.new
    end

    def run
      @rally.connect

      story = @rally.find_story_with_id @story_id

      puts Crab::CucumberFeature.new(@cmd_opts[:language]).generate_from story
    end
  end
end
