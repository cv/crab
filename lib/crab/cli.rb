require 'trollop'

module Crab

  SUB_COMMANDS = %w(pull login list)

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

Usage: crab [options] pull story1 [story2 ...]"
        end

        Crab::Pull.new(global_opts, cmd_opts, ARGV).run

      when "login"
        cmd_opts = Trollop::options do
          banner "crab login: logs into Rally

Usage: crab [options] login"
        end

        Crab::Login.new(global_opts, cmd_opts).run

      when "list"
        cmd_opts = Trollop::options do
          banner "crab list: lists stories in Rally

Usage: crab [options] list"
          opt :pagesize, "Number of items to fetch per page", :default => 100
          opt :project, "Project to use", :short => "-p", :type => String
        end

        Crab::List.new(global_opts, cmd_opts).run
      else
        if cmd
          Trollop::die "Unknown subcommand #{cmd.inspect}"
        else
          Trollop::die "Unknown subcommand"
        end
      end
    end
  end
end
