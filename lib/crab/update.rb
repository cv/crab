module Crab
  class Update
    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args

      @rally = Rally.new
    end

    def run
      opts = validate_and_fix_up_arguments

      @rally.connect

      story = @rally.find_story_with_id @args.first
      story.update opts

      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end

    def validate_and_fix_up_arguments
      Trollop::die "No story given" if @args.empty?

      opts = @cmd_opts.slice :name, :state, :estimate, :iteration, :release
      Trollop::die "Nothing to update. Please provide some options" if opts.all? {|k, v| v.nil? }

      opts[:plan_estimate] = opts.delete :estimate # nobody is going to remember "Plan Estimate", really
      opts[:blocked] = @cmd_opts[:blocked] if @cmd_opts[:blocked_given]
      opts[:blocked] = !@cmd_opts[:unblocked] if @cmd_opts[:unblocked_given]

      opts
    end
  end
end
