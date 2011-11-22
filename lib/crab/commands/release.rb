module Crab::Commands::Release

  class Main

    class << self

      include Crab::Utilities

      def run(args=ARGV)

        cmd = args.shift # get the subcommand

        case cmd
        when "-h", "--help", NilClass
          system "crab-release-help"
          exit 0
        end

        unless system("crab-release-#{cmd}", *args)
          if $?.exitstatus == 127 # bash 'command not found'
            logger.error "Unknown subcommand \"release #{cmd}\""
            system "crab-release-help"
            exit 1
          end
        end
      end
    end
  end
end
