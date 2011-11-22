class Crab::Commands::Release::Help

  def self.run
    puts <<-HELP
Usage: crab release <command> [options*]

  Available commands:

  list  List releases available in the current project
  help  Show this help text

     --help, -h:   Show this message
    HELP
  end
end
