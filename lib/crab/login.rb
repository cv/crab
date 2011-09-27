module Crab
  class Login

    include Utilities

    def initialize(global_opts, cmd_opts)
      @global_opts = global_opts
      @cmd_opts = cmd_opts
    end

    def run
      username = @cmd_opts[:username_given] ? @cmd_opts[:username] : ask("Username: ")
      password = @cmd_opts[:password_given] ? @cmd_opts[:password] : ask("Password: ") {|q| q.echo = false }

      File.open(credentials_file, 'w') do |file|
        file.puts username
        file.puts password
      end

      puts "Logged in as #{username}"
    end
  end
end
