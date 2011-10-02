module Crab
  module Utilities

    def logger
      $logger ||= Logger.new(STDOUT)
      $logger.formatter = Logger::Formatter.new
      $logger.progname = 'crab'
      # TODO - make this a global command-line or config option: $logger.level = Logger::WARN
      $logger
    end

    def credentials_file
      FileUtils.mkdir_p File.expand_path("~/.crab")
      File.expand_path("~/.crab/credentials")
    end

    def valid_credentials_file
      Trollop::die "Please log in first" unless File.exists? credentials_file
      credentials_file
    end

    def valid_project_name(cmd_opts)
      project_name = cmd_opts[:project_given] ? cmd_opts[:project] : current_project_name
      Trollop::die :project, "must be specified" if project_name.blank?
      project_name
    end

    def current_project_name
      if File.exists? ".crab/project"
        File.read(".crab/project").strip
      end
    end

    def state_from(option)
      fixed_option = option.gsub(/(^\w|[-_]\w)/) { $1.upcase.gsub(/_/, '-') }
      Trollop::die :state, "has an invalid value" unless Crab::Story::VALID_STATES.include? fixed_option
      fixed_option
    end

    def state_before(state)
      i = (Crab::Story::VALID_STATES.index(state) || 0) - 1
      Crab::Story::VALID_STATES[i < 0 ? 0 : i]
    end

    def state_after(state)
      i = (Crab::Story::VALID_STATES.index(state) || 0) + 1
      max = Crab::Story::VALID_STATES.size
      Crab::Story::VALID_STATES[i >= max ? max -1 : i]
    end

    # TODO REFACTOR testcase related stuff that didn't have a good home
    def add_or_update_options(banner, args)
      Trollop::options(args) do
        banner banner
        opt :priority, "Priority (one of: #{Crab::TestCase::PRIORITIES.join(" ")}", :default => "important", :short => '-p'
        opt :risk,     "Risk (one of: #{Crab::TestCase::RISKS.join(" ")})", :default => "medium", :short => '-r'
        opt :method,   "Method (one of: #{Crab::TestCase::METHODS.join(" ")})", :default => "automated", :short => '-m'
        opt :type,     "Type (one of: #{Crab::TestCase::TYPES.join(" ")})", :default => "acceptance", :short => '-t'
        opt :pre,      "Pre-conditions", :default => "N/A"
        opt :post,     "Post-conditions", :default => "N/A"
        opt :desc,     "Description", :default => "N/A", :short => '-d'

        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end
    end

    # TODO REFACTOR testcase related stuff that didn't have a good home
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
