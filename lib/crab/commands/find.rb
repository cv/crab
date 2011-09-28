module Crab::Commands

  class Find

    include Crab::Utilities

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args

      @cmd_opts = Trollop::options do
        banner "crab find: find a story in Rally

Usage: crab find [options] [text]"
        opt :project, "Project to use (required unless set by 'crab project')", :short => "-p", :type => String
      end

      @rally = Crab::Rally.new
    end

    def run
      pattern = @args.map(&:strip).reject(&:empty?)
      project_name = valid_project_name(@cmd_opts)

      @rally.connect

      project = @rally.find_project(project_name)

      Trollop::die "Project #{@cmd_opts[:project].inspect} not found" if project.nil?

      @rally.find_stories(project, pattern).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
