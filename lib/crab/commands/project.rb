module Crab::Commands
  class Project

    def self.current_project_name
      if File.exists? ".crab/project"
        File.read(".crab/project").strip
      end
    end

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args

      @cmd_opts = Trollop::options do
        banner "crab project: show or persistently select project to work with in Rally

Usage: crab project [name]"
      end

      @rally = Crab::Rally.new
    end

    def run
      current_project_name = self.class.current_project_name
      if current_project_name.present?
        puts current_project_name

      elsif @args.reject {|arg| arg.blank? }.empty?
        puts "No project currently selected."

      else
        name = @args.join(" ").strip

        @rally.connect

        project = @rally.find_project name
        Trollop::die "#{name.inspect} is not a valid project" if project.nil?

        FileUtils.mkdir_p ".crab"
        File.open(".crab/project", "w") do |file|
          file.puts project.name
        end
      end
    end
  end
end
