module Crab::Commands::Iteration
  class Main

    class << self

      include Crab::Utilities

      def run(args=ARGV)

        cmd = args.shift # get the subcommand

        case cmd
        when "-h", "--help", NilClass
          Crab::Commands::Iteration::Help.run
          exit 0
        end

        unless system("crab-iteration-#{cmd}", *args)
          if $?.exitstatus == 127 # bash 'command not found'
            logger.error "Unknown subcommand \"iteration #{cmd}\""
            Crab::Commands::Iteration::Help.run
            exit 1
          end
        end
      end
    end
  end
end
