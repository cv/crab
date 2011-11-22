class Crab::Commands::Story::Show

  def self.run(args=ARGV)
    opts = Trollop::options(args) do
      banner <<-BANNER
crab story show: displays a story in Rally as a Cucumber feature

Usage: crab story show <id> [options*]"
      BANNER
      opt :language, "Language to display Cucumber features in (ISO code)", :default => "en", :short => "-l"
      opt :testcases, "Also convert test cases to scenarios (similar to crab testcase show)", :short => "-t", :default => true
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    id = args.first
    Crab::Rally.new(opts[:dry]) do |rally|
      story = rally.find_story_with_id(id)

      puts Crab::CucumberFeature.new(opts[:language]).generate_from(story, opts[:testcases])
    end
  end
end
