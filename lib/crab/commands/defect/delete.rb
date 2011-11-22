class Crab::Commands::Defect::Delete

  def self.run(args=ARGV)
    opts = Trollop::options(args) do
      banner <<-BANNER
crab defect delete: delete an existing defect in Rally

Usage: crab defect delete <id> [options*]
      BANNER
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    id = args.join(" ")
    Trollop::die "Defect ID must be specified" if id.blank?

    Crab::Rally.new(opts[:dry]) do |rally|
      defect = rally.find_defect_with_id id
      defect.delete

      puts "Defect #{id} deleted."
    end
  end
end
