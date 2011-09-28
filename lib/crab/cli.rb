module Crab

  class CLI
    def self.start
      cmd = ARGV.shift # get the subcommand

      case cmd
      when "-h", "--help", NilClass
        system "crab-help"
        exit 0
      when "-v", "--version"
        system "crab-version"
        exit 0
      end

      unless system("crab-#{cmd}", *ARGV)
        if $?.exitstatus == 127 # bash 'command not found'
          $stderr.puts "Unknown subcommand #{cmd.inspect}"
          system "crab-help"
          exit 127
        end
      end
    end
  end
end
