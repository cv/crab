module Crab

  SUB_COMMANDS = %w(pull login list update show find project create delete testcase)

  class CLI
    def self.start
      global_opts = Trollop::options do
        version "crab version #{Crab::VERSION}"
        banner """
crab version #{Crab::VERSION}: A Cucumber-Rally bridge

  create   Create a new story in Rally
  delete   Delete an existing story in Rally
  find     Find stories by text in name, description or notes
  login    Persistently authenticate user with Rally
  project  Persistently select project to work with in Rally
  pull     Downloads stories (and its test cases) as Cucumber feature files
  show     Show a story (and its test cases) as a Cucumber feature
  testcase Manage test cases in a story (add, update, delete)
  update   Update a story (name, estimate, etc)
        """
        stop_on SUB_COMMANDS
      end

      cmd = ARGV.shift # get the subcommand
      Trollop::die "Unknown subcommand" unless cmd
      Trollop::die "Unknown subcommand #{cmd.inspect}" unless Crab::Commands.const_defined? cmd.capitalize

      Crab::Commands.const_get(cmd.capitalize).new(global_opts, ARGV).run
    end
  end
end
