require 'active_support/all'

module Crab

  class Pull

    def initialize(global_options, pull_options, story_numbers)
      @global_options = global_options
      @pull_options = pull_options
      @story_numbers = story_numbers
      @rally = Crab::Rally.new.connect
    end

    def run
      @story_numbers.each do |story_number|
        story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, story_number }.first
        Trollop::die "Could not find story with ID #{story_number}" if story.nil?

        filename = "#{story.formatted_i_d}-#{story.name.parameterize.dasherize}.feature"
        puts "#{story_number}: features/#{filename}"
        FileUtils.mkdir_p 'features'
        FileUtils.touch "features/#{filename}"
      end
    end
  end
end
