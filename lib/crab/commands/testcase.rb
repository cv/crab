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
        opts = add_or_update_options "crab testcase add: add a test case to a story in Rally"

        story_id = ARGV.shift
        name = ARGV.join(" ")
        add(story_id, name, opts)

      when "update"
        opts = add_or_update_options "crab testcase update: update a test case in Rally"

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
      tc = @rally.create_test_case(story_id, name, sanitize_options(opts))

      puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
    end

    def update(tc_id, opts)
      @rally.connect
      tc = @rally.find_test_case(tc_id)
      tc.update(sanitize_options(opts))
      puts "#{tc.story.formatted_id}/#{tc.formatted_id}: #{tc.name} (#{tc.tags.join(" ")})"
    end

    def delete(tc_id)
      @rally.connect
      tc = @rally.find_test_case(tc_id)
      tc.delete
      puts "Test case #{tc_id} deleted."
    end

    def add_or_update_options(banner)
      Trollop::options do
        banner banner
        opt :priority, "Priority (one of: #{Crab::TestCase::PRIORITIES.join(" ")}", :default => "important", :short => '-p'
        opt :risk,     "Risk (one of: #{Crab::TestCase::RISKS.join(" ")})", :default => "medium", :short => '-r'
        opt :method,   "Method (one of: #{Crab::TestCase::METHODS.join(" ")})", :default => "automated", :short => '-m'
        opt :type,     "Type (one of: #{Crab::TestCase::TYPES.join(" ")})", :default => "acceptance", :short => '-t'
        opt :pre,      "Pre-conditions", :default => "N/A"
        opt :post,     "Post-conditions", :default => "N/A"
        opt :desc,     "Description", :default => "N/A", :short => '-d'
      end
    end

    def sanitize_options(opts, creating=true)
      result = {}
      result[:priority] = opts[:priority].capitalize if creating || opts[:priority_given]
      result[:risk] = opts[:risk].capitalize if creating || opts[:risk_given]
      result[:method] = opts[:method].capitalize if creating || opts[:method_given]
      result[:type] = opts[:type].capitalize if creating || opts[:type_given]
      result[:pre_conditions] = opts[:pre] if creating || opts[:pre_given]
      result[:post_conditions] = opts[:post] if creating || opts[:post_given]
      result[:description] = opts[:desc] if creating || opts[:desc_given]
      result
    end
  end
end
