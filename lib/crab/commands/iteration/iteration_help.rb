class Crab::Commands::Iteration::Help

  def self.run
    puts <<-HELP
Usage: crab iteration <command> [options*]

  Available commands:

  list  List iterations available
  help  Show this help text

     --help, -h:   Show this message
    HELP
  end
end
