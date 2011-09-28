module Crab::Commands

  class Truncate

    include Crab::Utilities

    def initialize(args)
      @cmd_opts = Trollop::options do
        banner "crab truncate: Make spohr happy!"
      end
    end

    def run
      puts "You have been truncated! Now back to work!"
    end
  end
end
