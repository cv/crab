module Crab
  class Update
    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args

      @rally = Rally.new
    end

    def run
      Trollop::die "No story given" if @args.empty?
      story_id = @args.first
      opts = @cmd_opts.slice :name, :state, :estimate, :iteration, :release
      Trollop::die "Nothing to update. Please provide some options" if opts.all? {|k, v| v.nil? }

      opts[:plan_estimate] = opts.delete :estimate # nobody is going to remember "Plan Estimate", really

      @rally.connect

      story = @rally.find_story_with_id @args.first
      story.update opts

      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end
  end
end
