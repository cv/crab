module Crab
  class List

    include Utilities

    def initialize(global_opts, cmd_opts)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @rally = Rally.new
    end

    def run
      @rally.connect

      project_name = valid_project_name(@cmd_opts)

      opts = {
        :pagesize => @cmd_opts[:pagesize],
        :project  => @rally.find_project(project_name),
      }

      Trollop::die "Project #{@cmd_opts[:project].inspect} not found" if opts[:project].nil?

      @rally.find_all_stories(opts).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
