module Crab::Commands

  class Move

    include Crab::Utilities

    def initialize(args)
      @args = args

      @cmd_opts = Trollop::options do
        banner "crab move: move a story from one status to the next (or previous)

Usage: crab move story [options]"
        opt :back, "Move story backwards (from accepted to completed, for example)"
      end

      @rally = Crab::Rally.new
    end

    def run
      story_id = @args.join(" ")
      Trollop::die "No story given" if story_id.empty?

      @rally.connect

      story = @rally.find_story_with_id story_id
      state = state_from(story.state)

      story.update :schedule_state => (@cmd_opts[:back] ? state_before(state) : state_after(state))

      puts "#{story.formatted_id}: #{story.name} (#{story.state})"
    end

    def state_before(state)
      i = (Crab::Story::VALID_STATES.index(state) || 0) - 1
      Crab::Story::VALID_STATES[i < 0 ? 0 : i]
    end

    def state_after(state)
      i = (Crab::Story::VALID_STATES.index(state) || 0) + 1
      max = Crab::Story::VALID_STATES.size
      Crab::Story::VALID_STATES[i >= max ? max -1 : i]
    end
  end
end
