require 'rubygems'
require 'bundler/setup'

Bundler.require :default

require 'highline/import'

task :default do
  username = ask('Username: ') {|q| q.echo = true }
  password = ask('Password: ') {|q| q.echo = "*" }

  rally = RallyRestAPI.new :username => username, :password => password
  p rally
end
