class Crab::Commands::Logout

  class << self

    include Crab::Utilities

    def run(args=ARGV)

      opts = Trollop::options(args) do
        banner <<-BANNER
Usage: crab logout [options*]

Log out of Rally. Your credentials will be removed from current project directory or home folder (~/.crab/credentials).
        BANNER
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      fileutils_opts = opts[:dry] ? {:noop => true, :verbose => true} : {}
      file = credentials_file
      FileUtils.rm_rf(file, fileutils_opts)

      puts "Credentials removed from #{file}"

    end
  end
end
