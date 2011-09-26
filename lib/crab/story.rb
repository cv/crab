module Crab

  class Story

    def initialize(rally_story)
      @rally_story = rally_story
    end

    def name
      @rally_story.name
    end

    def filename
      "#{formatted_id}-#{name.parameterize.dasherize}.feature"
    end

    def formatted_id
      @rally_story.formatted_i_d
    end

  end

end
