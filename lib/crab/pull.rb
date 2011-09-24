module Crab

  class Pull

    def initialize(global_options, pull_options, stories)
      @global_options = global_options
      @pull_options = pull_options
      @stories = stories
    end

    def run
      @stories.each do |story|
        puts "#{story}: features/#{story}"
      end
    end

  end

end
