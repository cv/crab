class Crab::Commands::Story::Help

  def self.run
    puts <<-HELP
Usage: crab story <command> [options*]

  Available commands:

  create  Create stories
  delete  Delete stories
    find  Find stories
    help  This help message
    move  Move story status (from completed to accepted, etc)
    pull  Pull stories as Cucumber features
  rename  Rename stories
    show  Show stories as Cucumber features
  update  Update stories

     --help, -h:   Show this message
    HELP
  end
end
