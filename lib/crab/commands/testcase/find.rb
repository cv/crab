class Crab::Commands::TestCase::Find

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
crab testcase find: find a testcase in Rally

Usage: crab testcase find [options*] [text]
        BANNER
        opt :project,  "Project to use (required unless set by 'crab project')",    :short => "-p", :type => String
        opt :story,    "Limit search to testcases of this story",                   :short => "-s", :type => String
        opt :priority, "Priority (one of: #{Crab::TestCase::PRIORITIES.join(" ")}", :short => '-P', :type => String
        opt :risk,     "Risk (one of: #{Crab::TestCase::RISKS.join(" ")})",         :short => '-r', :type => String
        opt :method,   "Method (one of: #{Crab::TestCase::METHODS.join(" ")})",     :short => '-m', :type => String
        opt :type,     "Type (one of: #{Crab::TestCase::TYPES.join(" ")})",         :short => '-t', :type => String
        opt :dry,      "Dry-run (don't change anything)",                           :short => "-D", :default => false
      end

      pattern = args.map(&:strip).reject(&:empty?)
      project_name = valid_project_name(opts)

      Crab::Rally.new(opts[:dry]) do |rally|
        project = rally.find_project(project_name)
        Trollop::die "Project #{opts[:project].inspect} not found" if project.nil?

        find_opts = {}
        find_opts[:story] = rally.find_story_with_id opts[:story] if opts[:story_given]
        find_opts[:priority] = opts[:priority].capitalize if opts[:priority_given]
        find_opts[:method]   = opts[:method].capitalize   if opts[:method_given]
        find_opts[:type]     = opts[:type].capitalize     if opts[:type_given]
        find_opts[:risk]     = opts[:risk].capitalize     if opts[:risk_given]

        rally.find_testcases(project, pattern, find_opts).each do |tc|
          puts "#{tc.story.formatted_id if tc.story.rally_object}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
        end
      end
    end
  end
end
