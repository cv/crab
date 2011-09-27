module Crab
  class Project
    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args
      @rally = Rally.new
    end

    def run
      if File.exists? ".rally_project"
        puts File.read ".rally_project"
      elsif @args.reject {|arg| arg.blank? }.empty?
        puts "No project currently selected."
      else
        name = @args.join(" ").strip

        @rally.connect

        project = @rally.find_project name
        Trollop::die :project, "#{name.inspect} is not a valid project" if project.nil?

        File.open(".rally_project", "w") do |file|
          file.puts project.name
        end
      end
    end
  end
end
