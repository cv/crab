module Crab

  class CucumberFeature
    def generate_from(story)
      FileUtils.mkdir_p 'features'
      FileUtils.touch "features/#{story.filename}"
    end
  end

end
