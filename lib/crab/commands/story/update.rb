class Crab::Commands::Story::Update

  class << self

    include Crab::Utilities

    def run(args=ARGV)

      cmd_opts = Trollop::options(args) do
        banner <<-BANNER
crab story update: update a story in Rally

Usage: crab story update <id> [options*]
        BANNER
        opt :name,      "Name (title)", :type => String, :short => "-n"
        opt :description, "Description", :type => String, :short => "-d"
        opt :state,     "State (one of: #{Crab::Story::VALID_STATES.join(" ")})", :type => String, :short => "-t"
        opt :estimate,  "Estimate",     :type => :int,   :short => "-e"
        opt :iteration, "Iteration",    :type => String, :short => "-i"
        opt :release,   "Release",      :type => String, :short => "-r"
        opt :blocked,   "Blocked",      :short => "-b"
        opt :unblocked, "Unblocked",    :short => "-u"
        opt :parent,    "Parent",       :type => String, :short => "-p"
        opt :dry,       "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      Trollop::die "No story given" if args.empty?
      Trollop::die "Nothing to update. Please provide some options" unless cmd_opts.any? {|k, v| k.to_s =~ /_given$/ }

      opts = {}
      opts[:name] = cmd_opts[:name] if cmd_opts[:name_given]
      opts[:description] = cmd_opts[:description] if cmd_opts[:description_given]
      opts[:schedule_state] = state_from(cmd_opts[:state]) if cmd_opts[:state_given]

      if cmd_opts[:estimate_given]
        opts[:plan_estimate] = cmd_opts[:estimate] # nobody is going to remember "Plan Estimate", really
      end

      opts[:blocked] = cmd_opts[:blocked] if cmd_opts[:blocked_given]
      opts[:blocked] = !cmd_opts[:unblocked] if cmd_opts[:unblocked_given]

      Crab::Rally.new(opts[:dry]) do |rally|

        story = rally.find_story_with_id args.first

        if cmd_opts[:iteration_given]
          opts[:iteration] = rally.find_iteration_by_name cmd_opts[:iteration], story.rally_object.project
        end

        if cmd_opts[:release_given]
          opts[:release] = rally.find_release_by_name cmd_opts[:release], story.rally_object.project
        end

        if cmd_opts[:parent_given]
          opts[:parent] = rally.find_story_with_id(cmd_opts[:parent]).rally_object
        end

        opts[:name] = story.name if opts[:name].blank?

        story.update opts

        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end

    end
  end
end
