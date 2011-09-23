require 'rubygems'
require 'bundler/setup'

Bundler.require :default

task :ensure_credentials_are_present do
  ENV['RALLY_USERNAME'] ||= ask('Username: ')
  ENV['RALLY_PASSWORD'] ||= ask('Password: ') {|q| q.echo = "*" }
end

task :rally => :ensure_credentials_are_present do
  @rally = RallyRestAPI.new :username => ENV['RALLY_USERNAME'], :password => ENV['RALLY_PASSWORD']
  puts "Logged in as #{@rally.user.login_name}"
end

task :project => :rally do
  project = ENV['RALLY_PROJECT'] ||= ask('Project: ')
  @project = @rally.find(:project) { equal :name, ENV['RALLY_PROJECT']}.first
  puts "Using project \"#{ENV['RALLY_PROJECT']}\""
end

task :default => :rally do
  binding.pry
end

class Feature < Mustache

  self.template_path = File.join(File.dirname(__FILE__), 'templates')

  def initialize(rally_story, language=(ENV['CUCUMBER_LANG'] || ''))
    @delegate = rally_story
    self.class.template_file = File.join(self.class.template_path, "feature-#{language}.mustache") if language.present?
  end

  def name
    @delegate.name
  end

  def formatted_id
    @delegate.formatted_i_d
  end

  def state
    (@delegate.schedule_state || "unknown").parameterize.underscore
  end

  def description
    sanitize(@delegate.description || '').gsub(/  +/, "\n").gsub(/\n\n/, "\n").gsub(/\n/, "\n  ")
  end

  def file_name
    "#{formatted_id}_#{name.parameterize.underscore}.feature"
  end

  def dir_name
    state
  end

end

task :generate_features => :project do
  project = @project
  @stories = @rally.find(:hierarchical_requirement, :fetch => true) { equal :project, project }

  @stories.each do |story|
    feature = Feature.new(story)

    dir = File.join("features", feature.dir_name)
    file = File.join(dir, feature.file_name)

    FileUtils.mkdir_p dir
    FileUtils.touch file

    File.open(file, 'w') do |f|
      f.write feature.render
    end
    putc '.'
  end
  puts

end

class FeatureProxy
  def initialize
    @scenarios = []
    @steps = ActiveSupport::OrderedHash.new([])
  end

  attr_reader :scenarios, :steps

  def name
    @feature.name
  end

  def description
    @feature.description
  end

  def rally_id
    self.name.match(/^\[([^\]]+)\](.*)$/)
    $1
  end

  def title_for_rally
    self.name.match(/^\[([^\]]+)\](.*)$/)
    $2.squish.titleize
  end

  # needed by Gherkin
  def uri(uri)
  end

  def feature(feature)
    @feature = feature
  end

  def get
    @feature
  end

  def scenario(scenario)
    @scenarios << scenario
  end

  def step(step)
    @steps[@scenarios.last] += Array(step)
  end

  def eof
  end

  def has_story_id?
    !!self.name.match(/^\[([^\]]+)\](.*)$/)
  end
end

def parse(feature)
  updater = FeatureProxy.new
  parser = Gherkin::Parser::Parser.new(updater, false, "root", false)
  parser.parse File.read(feature), feature, 0
  updater
end

def sanitize(source)
  Sanitize.clean source, :remove_contents => %w{style}
end

task :update_features => :rally do
  Dir['features/**/*.feature'].sort {|a,b| File.mtime(b) <=> File.mtime(a) }.each do |file|
    feature = parse file
    unless feature.has_story_id?
      raise "Incompatible feature name: #{feature.name} in #{file} (needs to begin with a story number in square brackets)"
    end

    feature_id = feature.rally_id
    feature_name = feature.title_for_rally

    story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, feature_id }.first

    updates = {}

    if story.name != feature_name
      updates[:name] = feature_name
    end

    rally_description = sanitize(story.description   || '').gsub(/\s+/, ' ').strip
    cuke_description  = sanitize(feature.description || '').gsub(/\s+/, ' ').strip

    if rally_description != cuke_description
      formatted_description = (feature.description || '').strip.gsub(/\n/, '<br/>')
      updates[:description] = formatted_description
    end

    if updates.empty?
      puts "Nothing to do for #{feature_id} (story already up to date)"
    else
      story.update updates
      puts "Updated #{feature_id}: #{story.name} (#{updates.keys.join(',')})"
    end
  end
end

task :update_scenarios => :project do
  Dir['features/**/*.feature'].sort {|a,b| File.mtime(b) <=> File.mtime(a) }.each do |file|
    feature = parse file
    feature.steps.each do |scenario, steps|
      create_test_case @project, feature, scenario, steps
    end
  end
end

TYPE_TAGS = %w{acceptance functional non-functional performance regression usability user_interface}
RISK_TAGS = %w{low_risk medium_risk high_risk}
PRIORITY_TAGS = %{useful important critical}
METHOD_TAGS = %{automated manual}

def create_test_case(project, feature, scenario, steps)
  if !scenario.name.match /^\[([^\]]+)\](.*)$/
    # uh oh, we have to create this scenario!
    tags = scenario.tags.map {|t| t.name.gsub(/^@/, '') }

    type_tag = (tags.find {|t| TYPE_TAGS.include? t } || 'acceptance').humanize
    risk_tag = (tags.find {|t| RISK_TAGS.include? t } || 'medium_risk').gsub(/_risk/, '').humanize
    priority_tag = (tags.find {|t| PRIORITY_TAGS.include? t } || 'important').humanize
    method_tag = (tags.find {|t| METHOD_TAGS.include? t } || 'automated').humanize

    story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, feature.rally_id }.first

    options = {
      :name => scenario.name,
      :description => "Automatically updated by Cucumber, do not edit",
      :type => type_tag,
      :risk => risk_tag,
      :priority => priority_tag,
      :method => method_tag,
      :pre_conditions => "N/A",
      :post_conditions => "N/A",
      :work_product => story,
      :project => @project
    }

    test_case = @rally.create(:test_case, options) do |test_case|
      steps.each_with_index do |step, i|
        test_case_step = @rally.create(:test_case_step, :test_case => test_case, :index => i, :input => "#{step.keyword.strip} #{step.name.strip}")
      end
    end

    puts "Created test case #{test_case.formatted_i_d} in story #{feature.rally_id}"
  else
    # TODO update scenario text in feature with ID from Rally
  end
end

task :delete_all_test_cases => :project do
  story_id = ENV['STORY'] ||= ask("Story #: ")
  project = @project
  story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, story_id }.first
  test_cases = @rally.find(:test_case) { equal :work_product, story }

  test_cases.each do |tc|
    p tc.delete
  end
end
