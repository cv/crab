class Crab::Commands::TestCase::Delete

  def self.run(args=ARGV)
    Trollop::options(args) do
      banner <<-BANNER
crab testcase delete: delete a test case in Rally

Usage: crab testcase delete <id> [options*]
      BANNER
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    tc_id = args.shift
    Crab::Rally.new(opts[:dry]) do |rally|
      tc = rally.find_test_case(tc_id)
      tc.delete
      puts "Test case #{tc_id} deleted."
    end
  end
end
