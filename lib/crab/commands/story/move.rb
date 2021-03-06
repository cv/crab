class Crab::Commands::Story::Move

  class << self

    include Crab::Utilities

    def run(args=ARGV)

      opts = Trollop::options(args) do
        banner <<-BANNER
crab story move: move a story from one status to the next (or previous)

Usage: crab story move <id> [state] [options*]
        BANNER
        opt :back, "Move story backwards (from accepted to completed, for example)"
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      id = args.shift
      Trollop::die "No story given" if id.empty?

      Crab::Rally.new(opts[:dry]) do |rally|
        story = rally.find_story_with_id id

        state = args.shift
        if state.blank?
          state = (opts[:back] ? state_before(story.state) : state_after(story.state))
        else
          state = state_from(state)
        end

        story.update :schedule_state => state
        puts "#{story.formatted_id}: #{story.name} (#{story.state})"
      end
    end
  end
end
