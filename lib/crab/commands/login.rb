class Crab::Commands::Login

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
Usage: crab login [options*]

Log into Rally. Your credentials will be written to ~/.crab/credentials unless --project is specified.
        BANNER

        opt :username, "Username", :type => String, :short => "-u"
        opt :password, "Password", :type => String, :short => "-p"
        opt :project, "Store credentials into current folder", :short => "-P", :default => false
      end

      username = opts[:username_given] ? opts[:username] : ask("Username: ")
      password = opts[:password_given] ? opts[:password] : ask("Password: ") {|q| q.echo = false }

      crab_dir = if opts[:project]
        File.expand_path "./.crab"
      else
        File.expand_path "~/.crab"
      end

      FileUtils.mkdir_p crab_dir
      credentials_file = "#{crab_dir}/credentials"

      File.open(credentials_file, 'w') do |file|
        file.puts username
        file.puts password
      end

      puts "Credentials stored for #{username}"
    end
  end
end
