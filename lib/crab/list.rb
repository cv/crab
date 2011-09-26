module Crab
  class List

    def initialize(global_opts, cmd_opts)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @rally = Rally.new
    end

    def run
      @rally.connect

      Trollop::die :project, "must be specified" unless @cmd_opts[:project_given]

      opts = {
        :pagesize => @cmd_opts[:pagesize],
        :project  => @rally.find_project(@cmd_opts[:project]),
      }

      Trollop::die "Project #{@cmd_opts[:project].inspect} not found" if opts[:project].nil?

      @rally.find_all_stories(opts).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
