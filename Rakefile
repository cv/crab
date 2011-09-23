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

  def initialize(rally_story)
    @delegate = rally_story
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
    sanitize(@delegate.description || '').gsub(/  +/, "\n").gsub(/\n\n/, "\n").gsub(/\n/, "\n  # ")
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

class Updater
  def uri(uri)
  end

  def feature(feature)
    @feature = feature
  end

  def get
    @feature
  end

  def eof
  end
end

def parse(feature)
  updater = Updater.new
  parser = Gherkin::Parser::Parser.new(updater, false, "root", false)
  parser.parse File.read(feature), feature, 0
  updater.get
end

def sanitize(source)
  Sanitize.clean source, :remove_contents => %w{style}
end

task :update_features => :rally do
  Dir['features/**/*.feature'].each do |file|
    feature = parse file
    if !feature.name.match /^\[([^\]]+)\](.*)$/
      raise "Incompatible feature name: #{feature.name} in #{file} (needs to begin with a story number in square brackets)"
    end

    feature_id = $1
    feature_name = $2.squish.titleize

    story = @rally.find(:hierarchical_requirement) { equal :formatted_i_d, feature_id }.first

    updates = {}

    if story.name != feature_name
      updates[:name] = feature_name
    end

    p rally_description = sanitize(story.description).gsub(/\s+/, ' ').strip
    p cuke_description = sanitize(feature.description).gsub(/\s+/, ' ').strip

    if rally_description != cuke_description
      formatted_description = feature.description.strip.gsub(/\n/, '<br/>')
      updates[:description] = formatted_description
    end

    if updates.empty?
      puts "Nothing to do (story already up to date)"
    else
      story.update updates
      puts "Updated #{feature_id}: #{story.name} (#{updates.keys.join(',')})"
      p formatted_description
    end
  end
end

