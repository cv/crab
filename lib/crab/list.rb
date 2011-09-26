module Crab
  class List

    def initialize(global_opts, cmd_opts)
      @pagesize = cmd_opts[:pagesize]
      @project = cmd_opts[:project]
      @rally = Rally.new
    end

    def run
      @rally.connect

      Trollop::die :project, "must be specified" if @project.blank?

      opts = {
        :pagesize => @pagesize,
        :project  => @rally.find_project(@project),
      }

      Trollop::die "Project #{@project.inspect} not found" if opts[:project].nil?

      @rally.find_all_stories(opts).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
