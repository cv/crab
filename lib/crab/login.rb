require 'highline/import'

module Crab
  class Login

    include Utilities

    def initialize(global_opts, cmd_opts)
    end

    def run
      username = ask("Username: ")
      password = ask("Password: ") # {|q| q.echo = false }

      File.open(credentials_file, 'w') do |file|
        file.puts username
        file.puts password
      end
    end
  end
end
