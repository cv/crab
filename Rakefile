require 'rubygems'
require 'bundler/setup'

Bundler.require :default

task :ensure_credentials_are_present do
  ENV['RALLY_USERNAME'] ||= ask('Username: ') {|q| q.echo = true }
  ENV['RALLY_PASSWORD'] ||= ask('Password: ') {|q| q.echo = "*" }
end

task :rally => :ensure_credentials_are_present do
  @rally = RallyRestAPI.new :username => ENV['RALLY_USERNAME'], :password => ENV['RALLY_PASSWORD']
  puts "Logged in as #{@rally.user.login_name}."
end

task :project => :rally do
  @project = @rally.find(:project) { equal :name, ENV['RALLY_PROJECT']}.first
  puts "Using project \"#{ENV['RALLY_PROJECT']}\""
end

task :default => :rally do
  binding.pry
end

task :generate_features => :project do
  project = @project
  @stories = @rally.find(:artifact, :fetch => true) { equal :project, project }

  @stories.each do |story|
    state = story.schedule_state.parameterize.underscore
    name = "#{story.formatted_i_d}_#{story.name.parameterize.underscore}.feature"

    FileUtils.mkdir_p File.join("features", state)
    FileUtils.touch File.join("features", state, name)
  end
end

