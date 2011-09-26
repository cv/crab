module Crab
  class Show
    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @story_id = args.first
      @rally = Rally.new
    end

    def run
      @rally.connect

      story = @rally.find_story_with_id @story_id
      puts CucumberFeature.new.generate_from story
    end
  end
end
