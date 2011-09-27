module Crab
  class Project

    def self.current_project_name
      if File.exists? ".rally_project"
        File.read(".rally_project").strip
      end
    end

    def initialize(global_opts, cmd_opts, args)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
      @args = args
      @rally = Rally.new
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

        File.open(".rally_project", "w") do |file|
          file.puts project.name
        end
      end
    end
  end
end
