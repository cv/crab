module Crab
  class Rally

    include Crab::Utilities

    def initialize(dry_run)
      @dry_run = dry_run

      if block_given?
        connect
        yield self
      end
    end

    def connect
      get_credentials
      @rally = ::RallyRestAPI.new :username => @username, :password => @password
    end

    def get_credentials
      @username, @password = File.read(valid_credentials_file).split /\n/
    end

    def find_story_with_id story_id
      story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, story_id }.first
      Crab::Story.new(story, @dry_run)
    end

    def find_all_stories(opts={})
      @rally.find_all(:hierarchical_requirement, {:fetch => true}.merge(opts)).map do |story|
        Crab::Story.new(story, @dry_run)
      end
    end

    def find_stories(project, pattern=[])
      return find_all_stories :project => project if pattern.empty?

      rally_stories = @rally.find(:hierarchical_requirement, :fetch => true, :project => project) do
        pattern.each do |word|
          _or_ do
            contains :name, word
            contains :description, word
            contains :notes, word
          end
        end
      end

      rally_stories.map {|story| Crab::Story.new(story, @dry_run) }
    end

    def find_project(name)
      @rally.find(:project, :fetch => true) { equal :name, name }.first
    end

    def find_iteration_by_name(name)
      @rally.find(:iteration) { equal :name, name }.first
    end

    def find_release_by_name(name)
      @rally.find(:release) { equal :name, name }.first
    end

    def create_story(opts)
      if @dry_run
        Crab::DryRun::Story.new opts
      else
        Crab::Story.new(@rally.create(:hierarchical_requirement, opts), @dry_run)
      end
    end

    def create_test_case(story_id, name, opts)
      story = find_story_with_id story_id
      opts = {:name => name, :work_product => story.rally_object, :project => story.rally_object.project}.merge(opts)

      if @dry_run
        puts "Would create test case for story with ID #{story_id} with #{opts.inspect}"
      else
        tc = @rally.create(:test_case, opts)
        Crab::TestCase.new(tc, @dry_run)
      end
    end

    def find_test_case(tc_id)
      Crab::TestCase.new(@rally.find(:test_case) { equal :formatted_i_d, tc_id }.first, @dry_run)
    end

  end
end
