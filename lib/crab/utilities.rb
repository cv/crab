module Crab
  module Utilities
    def credentials_file
      File.expand_path("~/.rally_credentials")
    end

    def valid_credentials_file
      Trollop::die "Please log in first" unless File.exists? credentials_file
      credentials_file
    end

    def valid_project_name(cmd_opts)
      project_name = cmd_opts[:project_given] ? cmd_opts[:project] : Crab::Project.current_project_name
      Trollop::die :project, "must be specified" if project_name.blank?
      project_name
    end
  end
end
