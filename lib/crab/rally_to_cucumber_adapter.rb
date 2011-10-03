class Crab::RallyToCucumberAdapter

  def initialize(language)
    @language = language
  end

  def feature_from(story)
    comments = [Gherkin::Formatter::Model::Comment.new("# language: #{@language.iso_code}", 0)]
    tags = []
    keyword = @language.keywords('feature').last
    name = "[#{story.formatted_id}] #{story.name}"
    description = story.description
    line = 0

    Gherkin::Formatter::Model::Feature.new(comments, tags, keyword, name, description, line)
  end

  def scenario_from(test_case)
    comments = []
    tags = test_case.tags.map {|tag| Gherkin::Formatter::Model::Tag.new("@#{tag}", 0) }
    keyword = @language.keywords('scenario').last
    name = "[#{test_case.formatted_id}] #{test_case.name}"
    description = test_case.description
    line = 0

    Gherkin::Formatter::Model::Scenario.new(comments, tags, keyword, name, description, line)
  end

end
