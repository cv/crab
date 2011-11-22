class Crab::Commands::TestCase::Create

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = add_or_update_options <<-BANNER, args
crab testcase create: add a test case to a story in Rally

Usage: crab testcase create <story> --name <name> [options*]
      BANNER

      story_id = args.shift
      unless story_id
        logger.error "Error: Story ID not provided."
        system "crab-testcase-help"
        exit 1
      end

      unless opts[:name_given]
        logger.error "Error: Test case name not provided."
        exit 1
      end

      Crab::Rally.new(opts[:dry]) do |rally|
        tc = rally.create_test_case(story_id, name, sanitize_options(opts))
        puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
      end
    end
  end
end