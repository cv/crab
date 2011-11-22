module Crab::Commands::Defect

  class Main
    class << self

      include Crab::Utilities

      def run(args=ARGV)
        cmd = args.shift # get the subcommand

        case cmd
        when "-h", "--help", NilClass
          Crab::Commands::Defect::Help.run
          exit 0
        end

        unless system("crab-defect-#{cmd}", *args)
          if $?.exitstatus == 127 # bash 'command not found'
            logger.error "Unknown subcommand \"defect #{cmd}\""
            system "crab-defect-help"
            exit 1
          end
        end
      end
    end
  end
end
