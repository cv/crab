class Crab::Commands::Release::List

  class << self
    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
crab release list: list releases available in the current project

Usage: crab release list [options*]
        BANNER
        opt :project, "Project to use (required unless set by 'crab project')", :short => "-p", :type => String
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      pattern = args.map(&:strip).reject(&:empty?)
      project_name = valid_project_name(opts)

      Crab::Rally.new(opts[:dry]) do |rally|
        project = rally.find_project(project_name)
        Trollop::die "Project #{opts[:project].inspect} not found" if project.nil?

        rally.find_releases(project).each do |release|
          puts release.name
        end
      end
    end
  end
end
