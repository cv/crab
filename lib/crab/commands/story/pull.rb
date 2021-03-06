class Crab::Commands::Story::Pull

  def self.run(args=ARGV)
    opts = Trollop::options(args) do
      banner <<-BANNER
crab story pull: pulls stories from Rally and writes them out as Cucumber features

Usage: crab story pull <id> [id*] [options*]
      BANNER
      opt :language, "Language to generate Cucumber features in (ISO code)", :default => "en", :short => "-l"
      opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
    end

    Crab::Rally.new(opts[:dry]) do |rally|

      args.each do |story_number|
        story = rally.find_story_with_id story_number
        Trollop::die "Could not find story with ID #{story_number}" if story.nil?

        puts "#{story.formatted_id}: #{story.full_file_name}"

        fileutils_opts = opts[:dry] ? { :noop => true, :verbose => true } : {}

        FileUtils.mkdir_p File.dirname(story.full_file_name), fileutils_opts
        FileUtils.touch story.full_file_name, fileutils_opts

        output = Crab::CucumberFeature.new(opts[:language]).generate_from(story, true)

        if opts[:dry]
          puts "Would write to #{story.full_file_name}:\n\n#{output}"
        else
          File.open(story.full_file_name, "w") do |file|
            file.write output
          end
        end
      end
    end
  end
end
