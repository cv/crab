module Crab::Commands

  class Testcase

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args
      @rally = Crab::Rally.new

      @cmd_opts = Trollop::options do
        banner "crab testcase: manage test cases in a story (add, update, delete)

Usage: crab [options] testcase add story name [options]
       crab [options] testcase update testcase [options]
       crab [options] testcase delete testcase [options]"

        stop_on %w{add update delete}
      end
    end

    def run
      sub = ARGV.shift
      case sub
      when "add"
        opts = Trollop::options do
          banner "crab testcase add: add a test case to a story in Rally"
          opt :priority, "Priority (one of: #{Crab::TestCase::PRIORITIES.join(" ")}", :default => "important", :short => '-p'
          opt :risk,     "Risk (one of: #{Crab::TestCase::RISKS.join(" ")})", :default => "medium", :short => '-r'
          opt :method,   "Method (one of: #{Crab::TestCase::METHODS.join(" ")})", :default => "automated", :short => '-m'
          opt :type,     "Type (one of: #{Crab::TestCase::TYPES.join(" ")})", :default => "acceptance", :short => '-t'
          opt :pre,      "Pre-conditions", :default => "N/A"
          opt :post,     "Post-conditions", :default => "N/A"
          opt :desc,     "Description", :default => "N/A", :short => '-d'
        end

        story_id = ARGV.shift
        name = ARGV.join(" ")
        add(story_id, name, opts)

      when "update"
        opts = Trollop::options do
          banner "crab testcase update: update a test case in Rally"
          opt :priority, "Priority (one of: #{Crab::TestCase::PRIORITIES.join(" ")}", :default => "important", :short => '-p'
          opt :risk,     "Risk (one of: #{Crab::TestCase::RISKS.join(" ")})", :default => "medium", :short => '-r'
          opt :method,   "Method (one of: #{Crab::TestCase::METHODS.join(" ")})", :default => "automated", :short => '-m'
          opt :type,     "Type (one of: #{Crab::TestCase::TYPES.join(" ")})", :default => "acceptance", :short => '-t'
          opt :pre,      "Pre-conditions", :default => "N/A"
          opt :post,     "Post-conditions", :default => "N/A"
          opt :desc,     "Description", :default => "N/A", :short => '-d'
        end

        tc_id = ARGV.shift
        update(tc_id, opts)

      when "delete"
        Trollop::options do
          banner "crab testcase delete: delete a test case in Rally"
        end

        tc_id = ARGV.shift
        delete(tc_id)

      else
        Trollop::die "Unknown subcommand#{' ' + sub.inspect if sub}"
      end
    end

    def add(story_id, name, opts)
      @rally.connect
      tc = @rally.create_test_case(story_id, name, {
        :priority => opts[:priority].capitalize,
        :risk => opts[:risk].capitalize,
        :method => opts[:method].capitalize,
        :type => opts[:type].capitalize,
        :pre_conditions => opts[:pre],
        :post_conditions => opts[:post],
        :description => opts[:desc],
      })

      puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
    end

    def update(tc_id, opts)
      @rally.connect
      tc = @rally.find_test_case(tc_id)
      tc.update(opts)
      puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")}"
    end

    def delete
      @rally.connect
      tc = @rally.find_test_case(tc_id)
      tc.delete
      puts "Test case #{tc_id} deleted."
    end
  end
end
