module Crab
  class Find
    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args
      @rally = Rally.new
    end

    def run
      pattern = @args.map(&:strip).reject(&:empty?)
      Trollop::die "No search pattern given" if pattern.empty?
      Trollop::die :project, "must be specified" unless @cmd_opts[:project_given]

      @rally.connect

      project = @rally.find_project(@cmd_opts[:project])

      Trollop::die "Project #{@cmd_opts[:project].inspect} not found" if project.nil?

      @rally.find_story(project, pattern).each do |story|
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
