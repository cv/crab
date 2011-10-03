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
      logger.info "Connecting to Rally as #{@username}..."
      @rally = ::RallyRestAPI.new :username => @username, :password => @password
    end

    def get_credentials
      logger.info "Getting credentials..."
      @username, @password = File.read(valid_credentials_file).split /\n/
    end

    def find_story_with_id story_id
      logger.info "Looking up story with ID #{story_id}"
      story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, story_id }.first
      Trollop::die "Story with ID #{story_id.inspect} not found" if story.nil?
      Crab::Story.new(story, @dry_run)
    end

    def find_testcases(project, pattern, opts)
      logger.info "Looking for testcases matching #{pattern.inspect} with options #{opts.keys.inspect} in #{project.name.inspect}"

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

      rally_testcases.map {|tc| Crab::TestCase.new(tc, @dry_run) }.tap do |testcases|
        logger.info "Found #{testcases.size} test cases"
      end
    end

    def find_stories(project, pattern, opts)
      logger.info "Looking for stories matching #{pattern.inspect} with options #{opts.keys.inspect} in #{project.name.inspect}"
      if pattern.join.empty? && opts.empty?
        return @rally.find_all(:hierarchical_requirement, :fetch => true, :project => project).map {|s| Crab::Story.new(s, @dry_run) }
      end

      rally_stories = @rally.find(:hierarchical_requirement, :fetch => true, :project => project) do
        Crab::Rally.search_for_words_in pattern, self

        equal :iteration, opts[:iteration] if opts[:iteration]
        equal :release,   opts[:release]   if opts[:release]
        equal :parent,    opts[:parent].rally_object if opts[:parent]
      end

      rally_stories.map {|story| Crab::Story.new(story, @dry_run) }.tap do |stories|
        logger.info "Found #{stories.size} stories"
      end
    end

    def find_project(name)
      logger.info "Looking for project #{name.inspect}"
      @rally.find(:project, :fetch => true) { equal :name, name }.first
    end

    def find_iterations(project)
      logger.info "Looking for all iterations in #{project.name.inspect}"
      @rally.find_all(:iteration, :project => project)
    end

    def find_iteration_by_name(name, project)
      logger.info "Looking for iteration #{name.inspect} in #{project.name.inspect}"
      iteration = @rally.find(:iteration, :project => project) { equal :name, name }.first
      Trollop::die "Unknown iteration \"#{name}\"" if iteration.nil?
      iteration
    end

    def find_releases(project)
      logger.info "Looking for all releases in #{project.name.inspect}"
      @rally.find_all(:release, :project => project, :fetch => true)
    end

    def find_release_by_name(name, project)
      logger.info "Looking for release #{name.inspect} in #{project.name.inspect}"
      release = @rally.find(:release, :project => project) { equal :name, name }.first
      Trollop::die "Unknown release \"#{name}\"" if release.nil?
      release
    end

    def create_story(opts)
      logger.info "Creating story with #{opts.keys.inspect}"

      if @dry_run
        Crab::DryRun::Story.new opts
      else
        Crab::Story.new(@rally.create(:hierarchical_requirement, opts), @dry_run)
      end
    end

    def create_test_case(story_id, name, opts)
      story = find_story_with_id story_id
      opts = {:name => name, :work_product => story.rally_object, :project => story.rally_object.project}.merge(opts)

      logger.info "Creating test case with #{opts.keys.inspect}"

      if @dry_run
        puts "Would create test case for story with ID #{story_id} with #{opts.inspect}"
      else
        tc = @rally.create(:test_case, opts)
        Crab::TestCase.new(tc, @dry_run)
      end
    end

    def find_test_case(tc_id)
      logger.info "Looking up test case with ID #{tc_id}"
      tc = @rally.find(:test_case) { equal :formatted_i_d, tc_id }.first
      Trollop::die "Test case with ID #{tc_id.inspect} not found" if tc.nil?
      Crab::TestCase.new(tc, @dry_run)
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
