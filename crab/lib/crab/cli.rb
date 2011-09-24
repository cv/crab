require 'trollop'

module Crab

  SUB_COMMANDS = %w(pull)

  class CLI
    def self.start
      global_opts = Trollop::options do
        version "crab version #{Crab::VERSION}"
        opt :dry_run, "Don't actually do anything", :short => "-n"
        stop_on SUB_COMMANDS
      end

      cmd = ARGV.shift # get the subcommand
      case cmd
      when "pull" # parse delete options
        cmd_opts = Trollop::options do
          banner "crab pull: pulls stories from Rally and writes them out as Cucumber features

Usage: crab [options] pull story1 [story2 ...]
          """
        end

        Crab::Pull.new(global_opts, cmd_opts, ARGV).run

      else
        Trollop::die "Unknown subcommand #{cmd.inspect}"
      end
    end
  end
end
