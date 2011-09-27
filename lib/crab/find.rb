module Crab
  class Find

    include Utilities

    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args
      @rally = Rally.new
    end

    def run
      pattern = @args.map(&:strip).reject(&:empty?)
      Trollop::die "No search pattern given" if pattern.empty?

      project_name = valid_project_name(@cmd_opts)

      @rally.connect

      project = @rally.find_project(project_name)

      Trollop::die "Project #{@cmd_opts[:project].inspect} not found" if project.nil?

      @rally.find_story(project, pattern).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
