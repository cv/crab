module Crab

  class Create

    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args
      @rally = Rally.new
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
