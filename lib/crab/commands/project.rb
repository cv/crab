module Crab::Commands::Project
  class Main

    class << self

      include Crab::Utilities

      def run(args=ARGV)
        opts = Trollop::options(args) do
          banner <<-BANNER
crab project: show or persistently select project to work with in Rally

Usage: crab project [name] [options*]
          BANNER
          opt :clear, "Remove a previous project selection", :short => "-c", :default => false
          opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
        end

        name = args.join(" ").strip
        is_dry_run = opts[:dry] ? { :noop => true, :verbose => true } : {}

        if name.empty?
          if current_project_name.present?
            if opts[:clear]
              FileUtils.rm_rf dotcrab_file("project"), is_dry_run
              puts "Project selection removed."
            else
              puts current_project_name
            end
          else
            puts "No project currently selected."
          end
          exit 1
        end

        Crab::Rally.new(opts[:dry]) do |rally|
          project = rally.find_project name
          Trollop::die "#{name.inspect} is not a valid project" if project.nil?

          FileUtils.mkdir_p ".crab", is_dry_run
          file = ".crab/project"
          output = project.name

          if opts[:dry]
            puts "Would write to #{file}:\n\n#{output}"
          else
            File.open(file, "w") do |file|
              file.puts project.name
            end
          end
        end
      end
    end
  end
end
