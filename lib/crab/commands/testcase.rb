module Crab::Commands

  class Testcase

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args
      @cmd_opts = Trollop::options do
        banner "crab testcase: manage test cases in a story (add, update, delete)

Usage: crab [options] testcase add story name [options]
       crab [options] testcase update testcase [options]
       crab [options] testcase delete testcase [options]"
      end
    end

    def run
    end
  end
end
