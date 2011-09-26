module Crab
  class List

    def initialize(global_opts, cmd_opts)
      @pagesize = cmd_opts[:pagesize]
      @rally = Rally.new
    end

    def run
      @rally.connect

      @rally.find_all_stories(:pagesize => @pagesize).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
