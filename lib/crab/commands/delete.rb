module Crab::Commands

  class Delete

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args

      @cmd_opts = Trollop::options do
        banner "crab delete: delete an existing story in Rally

Usage: crab delete story [options]"
      end

      @rally = Crab::Rally.new
    end

    def run
      story_id = @args.join(" ")
      Trollop::die "Story ID must be specified" if story_id.blank?

      @rally.connect
      story = @rally.find_story_with_id story_id

      story.delete

      puts "Story #{story_id} deleted."
    end

  end
end
