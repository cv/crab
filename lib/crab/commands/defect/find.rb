class Crab::Commands::Defect::Find

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
crab defect find: find a defect in Rally

Usage: crab defect find [options*] [text]
        BANNER
        opt :project, "Project to use (required unless set by 'crab project')", :short => "-p", :type => String
        opt :iteration, "Limit search to this iteration",          :short => "-i", :type => String
        opt :release,   "Limit search to this release",            :short => "-r", :type => String
        opt :parent,    "Limit search to children of this defect", :short => "-P", :type => String
        opt :dry,       "Dry-run (don't change anything)",         :short => "-D", :default => false
      end

      pattern = args.map(&:strip).reject(&:empty?)
      project_name = valid_project_name(opts)

      Crab::Rally.new(opts[:dry]) do |rally|
        project = rally.find_project(project_name)
        Trollop::die "Project #{opts[:project].inspect} not found" if project.nil?

        find_opts = {}
        find_opts[:iteration] = rally.find_iteration_by_name opts[:iteration], project if opts[:iteration_given]
        find_opts[:release] = rally.find_release_by_name opts[:release], project if opts[:release_given]
        find_opts[:parent] = rally.find_defect_with_id opts[:parent] if opts[:parent_given]

        rally.find_defects(project, pattern, find_opts).each do |defect|
          puts "#{defect.formatted_id}: #{defect.name} (#{defect.state})"
        end
      end
    end
  end
end
