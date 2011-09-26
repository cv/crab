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
      opts = validate_and_fix_up_arguments_with_rally(story, opts)

      story.update opts

      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end

    def validate_and_fix_up_arguments
      Trollop::die "No story given" if @args.empty?

      opts = @cmd_opts.slice :name, :state, :estimate # "easy" options go here, others we need to parse, find etc
      Trollop::die "Nothing to update. Please provide some options" unless @cmd_opts.any? {|k, v| k.to_s =~ /_given$/ }

      opts[:plan_estimate] = opts.delete :estimate # nobody is going to remember "Plan Estimate", really
      opts[:blocked] = @cmd_opts[:blocked] if @cmd_opts[:blocked_given]
      opts[:blocked] = !@cmd_opts[:unblocked] if @cmd_opts[:unblocked_given]

      opts
    end

    def validate_and_fix_up_arguments_with_rally(story, opts)
      if @cmd_opts[:iteration_given]
        opts[:iteration] = @rally.find_iteration_by_name @cmd_opts[:iteration]
        Trollop::die "Unknown iteration \"#{@cmd_opts[:iteration]}\"" if opts[:iteration].nil?
      end

      opts[:name] = story.name if opts[:name].blank?
      opts
    end
  end
end
