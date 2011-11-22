class Crab::Commands::TestCase::Help

  def self.run
    puts <<-HELP
Usage: crab testcase <command> [options*]

  Available commands:

  create  Create a new test case in a story
  delete  Delete an existing test case
    find  Find test cases
    help  Show this help text
    list  List test cases in a story
    show  Show a test case (and its steps) as a Cucumber scenario
  update  Update a test case (name, priority, testing method, etc)

     --help, -h:   Show this message
    HELP
  end
end
