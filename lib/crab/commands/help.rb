class Crab::Commands::Help

  def self.run
    puts <<-HELP
Usage: crab <command> [options*]

crab version #{Crab::VERSION}: A Cucumber-Rally bridge

  Available commands:

       help  Show this help text
      login  Persistently authenticate user with Rally
     logout  Remove stored Rally credentials
    project  Persistently select project to work with in Rally

     defect  Manipulate defects
  iteration  Manipulate iterations
    release  Manipulate releases
      story  Manipulate stories
   testcase  Manipulate test cases

  --version, -v:   Print version and exit
     --help, -h:   Show this message
    HELP
  end
end
