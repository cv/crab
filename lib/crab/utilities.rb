module Crab
  module Utilities
    def credentials_file
      File.expand_path("~/.rally_credentials")
    end

    def valid_credentials_file
      Trollop::die "Please log in first" unless File.exists? credentials_file
      credentials_file
    end
  end
end
