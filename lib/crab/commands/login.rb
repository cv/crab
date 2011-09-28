module Crab::Commands

  class Login

    include Crab::Utilities

    def initialize(args)
      @cmd_opts = Trollop::options do
        banner "crab login: logs into Rally

Usage: crab login [options]"
        opt :username, "Username", :type => String, :short => "-u"
        opt :password, "Password", :type => String, :short => "-p"
      end
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
