module Crab::Commands::Story

  class Main

    class << self

      include Crab::Utilities

      def run(args=ARGV)
        cmd = args.shift # get the subcommand

        case cmd
        when "-h", "--help", NilClass
          Crab::Commands::Story::Help.run
          exit 0
        end

        unless system("crab-story-#{cmd}", *args)
          if $?.exitstatus == 127 # bash 'command not found'
            logger.error "Unknown subcommand \"story #{cmd}\""
            Crab::Commands::Story::Help.run
            exit 1
          end
        end
      end
    end
  end
end
