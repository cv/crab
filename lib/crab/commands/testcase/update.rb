class Crab::Commands::TestCase::Update

  class << self
    include Crab::Utilities

    def run(args=ARGV)
      opts = add_or_update_options <<-BANNER, args
crab testcase update: update a test case in Rally

Usage: crab testcase update <id> [options*]
      BANNER

      tc_id = args.shift

      Crab::Rally.new(opts[:dry]) do |rally|
        tc = rally.find_test_case(tc_id)
        tc.update(sanitize_options(opts))
        puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
      end
    end
  end
end
