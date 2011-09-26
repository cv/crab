require 'rally_rest_api'

module Crab
  class Rally

    include Utilities

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

    def find_project(name)
      @rally.find(:project, :fetch => true) { equal :name, name }.first
    end

    def find_iteration_by_name(name)
      @rally.find(:iteration) { equal :name, name }.first
    end

  end
end
