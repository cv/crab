require 'rubygems'
require 'bundler/setup'

Bundler.require :default

require 'highline/import'

task :ensure_credentials_are_present do
  ENV['RALLY_USERNAME'] ||= ask('Username: ') {|q| q.echo = true }
  ENV['RALLY_PASSWORD'] ||= ask('Password: ') {|q| q.echo = "*" }
end

task :connect_to_rally do
  @rally = RallyRestAPI.new :username => ENV['RALLY_USERNAME'], :password => ENV['RALLY_PASSWORD']
  puts "Logged in as #{@rally.user.login_name}."
end

task :default => [:ensure_credentials_are_present, :connect_to_rally] do
  artifacts = @rally.find_all :artifact
  artifacts.each do |a|
    puts a.name
  end
end
