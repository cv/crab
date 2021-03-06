class Crab::Commands::TestCase::Show

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
crab testcase show: displays a testcase in Rally as a Cucumber scenario

Usage: crab testcase show <id> [options*]"
        BANNER
        opt :language, "Language to display Cucumber features in (ISO code)", :default => "en", :short => "-l"
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      id = args.shift
      unless id
        logger.error "Error: No test case ID provided."
        Crab::Commands::TestCase::Help
        exit 1
      end

      Crab::Rally.new(opts[:dry]) do |rally|
        tc = rally.find_test_case id
        puts Crab::CucumberScenario.new(opts[:language]).generate_from(tc).strip
      end
    end
  end
end
