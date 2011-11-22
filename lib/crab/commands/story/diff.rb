class Crab::Commands::Story::Diff

  class << self

    include Crab::Utilities

    def run(args=ARGV)
      opts = Trollop::options(args) do
        banner <<-BANNER
crab story diff: compares Cucumber feature files with their Rally counterparts

Usage: crab story diff <file> [file*] [options*]
        BANNER

        opt :language, "Language to generate Cucumber features in (ISO code)", :default => "en", :short => "-l"
        opt :dry, "Dry-run (don't change anything)", :short => "-D", :default => false
      end

      filenames = args.map do |filename|
        Trollop::die "File does not exist: #{filename}" unless File.exists? filename
        File.expand_path filename
      end

      Crab::Rally.new(opts[:dry]) do |rally|
        filenames.each do |filename|

          feature = parse_feature_in filename

          show_args = "#{feature.story_id} #{"--language #{opts[:language]}" if opts[:language_given]} #{"--dry" if opts[:dry]}"
          logger.info "About to invoke 'crab-story-show #{show_args}'"
          rally_story_text = `crab-story-show #{show_args}`

          Open3.popen3 "diff #{filename} -" do |stdin, stdout, stderr|
            stdin.puts rally_story_text
            stdin.close

            puts stdout.read
          end
        end
      end
    end

    def parse_feature_in(filename)
      logger.info "Parsing #{filename}"
      Crab::CucumberToRallyAdapter.new File.read(filename), filename
    end
  end
end
