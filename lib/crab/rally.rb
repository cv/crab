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
      Trollop::die "Story with ID #{story_id.inspect} not found" if story.nil?
      Crab::Story.new(story, @dry_run)
    end

    def find_testcases(project, pattern, opts)
      if pattern.join.empty? && opts.empty?
        return @rally.find_all(:test_case, :fetch => true, :project => project).map {|tc| Crab::TestCase.new(tc, @dry_run) }
      end

      rally_testcases = @rally.find(:test_case, :fetch => true, :project => project) do
        Crab::Rally.search_for_words_in pattern, self

        equal :work_product, opts[:story].rally_object if opts[:story]
        equal :risk,     opts[:risk].capitalize     if opts[:risk]
        equal :method,   opts[:method].capitalize   if opts[:method]
        equal :priority, opts[:priority].capitalize if opts[:priority]
        equal :type,     opts[:type].capitalize     if opts[:type]
      end

      rally_testcases.map {|tc| Crab::TestCase.new(tc, @dry_run) }
    end

    def find_stories(project, pattern, opts)
      if pattern.join.empty? && opts.empty?
        return @rally.find_all(:hierarchical_requirement, :fetch => true, :project => project).map {|s| Crab::Story.new(s, @dry_run) }
      end

      rally_stories = @rally.find(:hierarchical_requirement, :fetch => true, :project => project) do
        Crab::Rally.search_for_words_in pattern, self

        equal :iteration, opts[:iteration] if opts[:iteration]
        equal :release,   opts[:release]   if opts[:release]
        equal :parent,    opts[:parent].rally_object if opts[:parent]
      end

      rally_stories.map {|story| Crab::Story.new(story, @dry_run) }
    end

    def find_project(name)
      @rally.find(:project, :fetch => true) { equal :name, name }.first
    end

    def find_iterations(project)
      @rally.find_all(:iteration, :project => project)
    end

    def find_iteration_by_name(name, project)
      iteration = @rally.find(:iteration, :project => project) { equal :name, name }.first
      Trollop::die "Unknown iteration \"#{name}\"" if iteration.nil?
      iteration
    end

    def find_releases(project)
      @rally.find_all(:release, :project => project, :fetch => true)
    end

    def find_release_by_name(name, project)
      release = @rally.find(:release, :project => project) { equal :name, name }.first
      Trollop::die "Unknown release \"#{name}\"" if release.nil?
      release
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

    private

    def self.search_for_words_in(pattern, query)
      unless pattern.join.empty?
        query._or_ do
          (pattern.map(&:downcase) + pattern.map(&:capitalize)).each do |word|
            contains :name, word
            contains :description, word
            contains :notes, word
          end
        end
      end
    end
  end
end
