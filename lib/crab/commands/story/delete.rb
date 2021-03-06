class Crab::Commands::Story::Delete

  def self.run(args=ARGV)
    opts = Trollop::options(args) do
      banner <<-BANNER
crab story delete: delete an existing story in Rally

Usage: crab story delete <id> [options*]
      BANNER
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    id = args.join(" ")
    Trollop::die "Story ID must be specified" if id.blank?

    Crab::Rally.new(opts[:dry]) do |rally|
      story = rally.find_story_with_id id
      story.delete

      puts "Story #{id} deleted."
    end
  end
end
