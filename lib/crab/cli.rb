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
      case cmd
      when "pull"
        Crab::Commands::Pull.new(global_opts, ARGV).run

      when "show"
        Crab::Commands::Show.new(global_opts, ARGV).run

      when "login"
        Crab::Commands::Login.new(global_opts, ARGV).run

      when "update"
        Crab::Commands::Update.new(global_opts, ARGV).run

      when "find"
        Crab::Commands::Find.new(global_opts, ARGV).run

      when "project"
        Crab::Commands::Project.new(global_opts, ARGV).run

      when "create"
        Crab::Commands::Create.new(global_opts, ARGV).run

      when "delete"
        Crab::Commands::Delete.new(global_opts, ARGV).run

      when "testcase"
        Crab::Commands::Testcase.new(global_opts, ARGV).run

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
