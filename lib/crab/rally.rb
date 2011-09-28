module Crab
  class Rally

    include Crab::Utilities

    def initialize
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
      Crab::Story.new @rally.find(:hierarchical_requirement) { equal :formatted_i_d, story_id }.first
    end

    def find_all_stories(opts={})
      @rally.find_all(:hierarchical_requirement, {:fetch => true}.merge(opts)).map {|s| Crab::Story.new s }
    end

    def find_stories(project, pattern=[])
      return find_all_stories :project => project if pattern.empty?

      @rally.find(:hierarchical_requirement, :fetch => true, :project => project) {
        pattern.each do |word|
          _or_ {
            contains :name, word
            contains :description, word
            contains :notes, word
          }
        end
      }.map {|s| Crab::Story.new s }
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
      Crab::Story.new @rally.create(:hierarchical_requirement, opts)
    end

    def create_test_case(story_id, name, opts)
      story = find_story_with_id story_id
      Crab::TestCase.new @rally.create(:test_case, {:name => name, :work_product => story.rally_object, :project => story.rally_object.project}.merge(opts))
    end

    def find_test_case(tc_id)
      Crab::TestCase.new @rally.find(:test_case) { equal :formatted_i_d, tc_id }.first
    end

  end
end
