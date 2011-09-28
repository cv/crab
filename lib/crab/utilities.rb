module Crab
  module Utilities

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

  end
end
