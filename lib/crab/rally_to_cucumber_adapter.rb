class Crab::RallyToCucumberAdapter

  include Crab::Utilities

  def initialize(language)
    @language = language
  end

  def feature_from(story)
    comments = [
      "# language: #{@language.iso_code}",
      "# state: #{story.state}",
      "# fetched: #{DateTime.now}",
      "# revision: #{story.revision}",
    ].map {|c| Gherkin::Formatter::Model::Comment.new(c, 0) }
    tags = []
    keyword = @language.keywords('feature').last
    name = "[#{story.formatted_id}] #{story.name}"
    description = story.description
    line = 0

    Gherkin::Formatter::Model::Feature.new(comments, tags, keyword, name, description, line, nil)
  end

  def scenario_from(test_case)
    comments = [
      "# revision: #{test_case.revision}",
    ].map {|c| Gherkin::Formatter::Model::Comment.new(c, 0) }
    tags = test_case.tags.map {|tag| Gherkin::Formatter::Model::Tag.new("@#{tag}", 0) }
    keyword = @language.keywords('scenario').last
    name = "[#{test_case.formatted_id}] #{test_case.name}"
    description = test_case.description
    line = 0

    Gherkin::Formatter::Model::Scenario.new(comments, tags, keyword, name, description, line)
  end

  def steps_from(test_case)
    test_case.steps.tap {|steps| logger.info "#{test_case.formatted_id}: #{steps.size} step(s) found"}.map do |step|
      step_words = step.split(' ')
      comments = []
      keyword = step_words.shift
      name = " " + step_words.join(' ')
      line = 0

      Gherkin::Formatter::Model::Step.new(comments, keyword, name, line)
    end
  end

end
