module Crab

  class Story

    include Crab::Utilities

    VALID_STATES = %w{Grooming Defined In-Progress Completed Accepted Released}

    def initialize(rally_story, dry_run)
      @rally_story = rally_story
      @dry_run = dry_run
    end

    def name
      @rally_story.name
    end

    def file_name
      "#{formatted_id}-#{name.parameterize.dasherize}.feature"
    end

    def full_file_name
      "features/#{state}/#{file_name}"
    end

    def formatted_id
      @rally_story.formatted_i_d
    end

    def state
      (@rally_story.schedule_state || "unknown").parameterize.underscore
    end

    def revision
      rev = @rally_story.revision_history.revisions.first
      "#{rev.revision_number}, by #{rev.user}"
    end

    def description
      sanitize(@rally_story.description || '')
    end

    def scenarios
      Array(@rally_story.test_cases).map {|tc| Crab::TestCase.new(tc, @dry_run) }
    end

    def test_cases
      scenarios
    end

    def update(opts)
      if @dry_run
        puts "Would update story #{formatted_id} with #{opts.inspect}"
      else
        @rally_story.update opts
      end
    end

    def delete
      if @dry_run
        puts "Would delete story #{formatted_id}"
      else
        @rally_story.delete
      end
    end

    def rally_object
      @rally_story
    end

    private

  end

  module DryRun
    class Story
      def initialize(opts)
        puts "Would create story with #{opts.inspect}"

        @name = opts[:name]
      end

      def name
        @name
      end

      def formatted_id
        "USXXXX"
      end

      def state
        "grooming"
      end

      def description
        ""
      end

      def scenarios
        []
      end

    end
  end
end

