class Crab::Commands::Main

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      cmd = args.shift # get the subcommand

      case cmd
      when "-h", "--help", NilClass
        Crab::Commands::Help.run
        exit 0
      when "-v", "--version"
        Crab::Commands::Version.run
        exit 0
      end

      unless system("crab-#{cmd}", *args)
        if $?.exitstatus == 127 # bash 'command not found'
          logger.error "Unknown subcommand #{cmd.inspect}"
          Crab::Commands::Help.run
          exit 127
        end
      end
    end
  end
end
