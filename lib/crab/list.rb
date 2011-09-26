module Crab
  class List

    def initialize(global_opts, cmd_opts)
      @pagesize = cmd_opts[:pagesize]
      @project = cmd_opts[:project]
      @rally = Rally.new
    end

    def run
      @rally.connect

      opts = {:pagesize => @pagesize}
      if @project
        opts[:project] = @rally.find_project @project
      end

      @rally.find_all_stories(opts).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
