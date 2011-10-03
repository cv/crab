class Crab::CucumberToRallyAdapter

  def initialize(feature_text, feature_file)
    @scenarios = []
    @steps = ActiveSupport::OrderedHash.new []

    parser = Gherkin::Parser::Parser.new(self, false, "root", false)
    parser.parse feature_text, feature_file, 0
  end

  attr_reader :scenarios, :steps

  # Rally compat
  def story_id
    @feature.name.match(/^\[([^\]]+)\](.*)$/)
    $1.strip
  end

  def name
    @feature.name.match(/^\[([^\]]+)\](.*)$/)
    $2.strip
  end

  def description
    @feature.description
  end

  # Cucumber compat
  def uri(uri)
    @uri
  end

  def feature(feature)
    @feature = feature
  end

  def scenario(scenario)
    @scenarios << scenario
  end

  def step(step)
    @steps[@scenarios.last] += Array(step)
  end

  def eof
  end

end
