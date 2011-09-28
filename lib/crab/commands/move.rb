module Crab::Commands

  class Move

    def initialize(global_opts, args)
      @global_opts = global_opts
      @args = args

      @cmd_opts = Trollop::options do
        banner "crab move: move a story from one status to the next (or previous)

Usage: crab [options] move story [options]"
        opt :back, "Move story backwards (from accepted to completed, for example)"
      end
    end

    def run
    end

  end
end
