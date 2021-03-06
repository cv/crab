class Crab::Commands::Story::Create

  def self.run(args=ARGV)
    opts = Trollop::options(args) do
      banner <<-BANNER
crab story create: create a new story in Rally

Usage: crab story create <name> [options*]
      BANNER
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    name = args.join(" ")
    Trollop::die "Please specify a name for the story" if name.blank?

    Crab::Rally.new(opts[:dry]) do |rally|
      story = rally.create_story :name => name
      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end
  end
end
