class Crab::Commands::Defect::Help

  def self.run
    puts <<-HELP
Usage: crab defect <command> [options*]

  Available commands:

  create  Create a new defect in a story
  delete  Delete an existing defect
    find  Find defects
    help  Show this help text
    list  List defects
    show  Show a defect (and its steps) as a Cucumber scenario
  update  Update a defect

     --help, -h:   Show this message
    HELP
  end
end
