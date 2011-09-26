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

  end
end