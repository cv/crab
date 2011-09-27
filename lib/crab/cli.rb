require 'trollop'

module Crab

  SUB_COMMANDS = %w(pull login list update show find)

  class CLI
    def self.start
      global_opts = Trollop::options do
        version "crab version #{Crab::VERSION}"
        banner """
crab version #{Crab::VERSION}: A Cucumber-Rally bridge

  login   Persistently authenticate user with Rally
  list    Lists stories
  update  Update a story (name, estimate, etc)
  show    Show a story (and its test cases) as a Cucumber feature
  pull    Downloads stories (and its test cases) as Cucumber feature files
  find    Find stories by text in name, description or notes
        """
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

      when "show"
        cmd_opts = Trollop::options do
          banner "crab show: displays a story in Rally as a Cucumber feature

Usage: crab [options] show story"
        end

        Crab::Show.new(global_opts, cmd_opts, ARGV).run

      when "login"
        cmd_opts = Trollop::options do
          banner "crab login: logs into Rally

Usage: crab [options] login"
          opt :username, "Username", :type => String, :short => "-u"
          opt :password, "Password", :type => String, :short => "-p"
        end

        Crab::Login.new(global_opts, cmd_opts).run

      when "list"
        cmd_opts = Trollop::options do
          banner "crab list: lists stories in Rally

Usage: crab [options] list"
          opt :pagesize, "Number of items to fetch per page", :short => "-s", :default => 100
          opt :project, "Project to use", :short => "-p", :type => String
        end

        Crab::List.new(global_opts, cmd_opts).run

      when "update"
        cmd_opts = Trollop::options do
          banner "crab update: update a story in Rally

Usage: crab [options] update story [options]"
          opt :name,      "Name (title)", :type => String, :short => "-n"
          opt :state,     "State (one of: #{Crab::Story::VALID_STATES.join(" ")})", :type => String, :short => "-t"
          opt :estimate,  "Estimate",     :type => :int,   :short => "-e"
          opt :iteration, "Iteration",    :type => String, :short => "-i"
          opt :release,   "Release",      :type => String, :short => "-r"
          opt :blocked,   "Blocked",      :short => "-b"
          opt :unblocked, "Unblocked",    :short => "-u"
          opt :parent,    "Parent",       :type => String, :short => "-p"
        end

        Crab::Update.new(global_opts, cmd_opts, ARGV).run

      when "find"
        cmd_opts = Trollop::options do
          banner "crab find: find a story in Rally

Usage: crab [options] find [options] text"
          opt :project, "Project to use", :short => "-p", :type => String
        end

        Crab::Find.new(global_opts, cmd_opts, ARGV).run

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
