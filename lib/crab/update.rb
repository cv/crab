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
      Trollop::die "Nothing to update. Please provide some options" unless @cmd_opts.any? {|k, v| k.to_s =~ /_given$/ }

      opts = {}
      opts[:name] = @cmd_opts[:name] if @cmd_opts[:name_given]
      opts[:schedule_state] = state_from(@cmd_opts[:state]) if @cmd_opts[:state_given]

      if @cmd_opts[:estimate_given]
        opts[:plan_estimate] = @cmd_opts[:estimate] # nobody is going to remember "Plan Estimate", really
      end

      opts[:blocked] = @cmd_opts[:blocked] if @cmd_opts[:blocked_given]
      opts[:blocked] = !@cmd_opts[:unblocked] if @cmd_opts[:unblocked_given]

      opts
    end

    def validate_and_fix_up_arguments_with_rally(story, opts)
      if @cmd_opts[:iteration_given]
        opts[:iteration] = @rally.find_iteration_by_name @cmd_opts[:iteration]
        Trollop::die "Unknown iteration \"#{@cmd_opts[:iteration]}\"" if opts[:iteration].nil?
      end

      if @cmd_opts[:release_given]
        opts[:release] = @rally.find_release_by_name @cmd_opts[:release]
        Trollop::die "Unknown release \"#{@cmd_opts[:release]}\"" if opts[:release].nil?
      end

      if @cmd_opts[:parent_given]
        opts[:parent] = @rally.find_story_with_id(@cmd_opts[:parent]).rally_object
        Trollop::die "Unknown story \"#{@cmd_opts[:parent]}\"" if opts[:parent].nil?
      end

      opts[:name] = story.name if opts[:name].blank?
      opts
    end

    def state_from(option)
      fixed_option = option.gsub(/(^\w|[-_]\w)/) { $1.upcase.gsub(/_/, '-') }
      Trollop::die :state, "has an invalid value" unless Crab::Story::VALID_STATES.include? fixed_option
      fixed_option
    end
  end
end
