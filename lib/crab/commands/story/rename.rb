class Crab::Commands::Story::Rename

  class << self

    def run(args=ARGV)

      include Crab::Utilities

      opts = Trollop::options(args) do
        banner <<-BANNER
crab story rename: rename a story

Usage: crab story rename <id> <name> [options*]
        BANNER
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      id = args.shift
      Trollop::die "No story given" if id.empty?

      name = args.join(" ").squish
      Trollop::die "No name given" if name.empty?

      Crab::Rally.new(opts[:dry]) do |rally|
        story = rally.find_story_with_id id

        story.update :name => name

        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
