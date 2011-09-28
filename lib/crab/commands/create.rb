module Crab::Commands

  class Create

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args
      @cmd_opts = Trollop::options do
        banner "crab create: create a new story in Rally

Usage: crab create name [options]"
      end
      @rally = Crab::Rally.new
    end

    def run
      name = @args.join(" ")
      Trollop::die "Please specify a name for the story" if name.blank?

      @rally.connect
      story = @rally.create_story :name => name

      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end

  end
end
