module Crab::Commands::TestCase
  class Main

    class << self

      include Crab::Utilities

      def run(args=ARGV)
        cmd = args.shift # get the subcommand

        case cmd
        when "-h", "--help", NilClass
          Crab::Commands::TestCase::Help.run
          exit 0
        end

        unless system("crab-testcase-#{cmd}", *args)
          if $?.exitstatus == 127 # bash 'command not found'
            logger.error "Unknown subcommand \"testcase #{cmd}\""
            Crab::Commands::TestCase::Help.run
            exit 1
          end
        end
      end
    end
  end
end
