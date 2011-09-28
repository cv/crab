require "bundler/gem_tasks"
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => :features

namespace :cucumber do

  desc "Basic test suite set-up"
  task :setup do
    require 'highline/import'

    puts """
In order to run the Cucumber tests for crab itself, we need a few
details from you. These are stored in ~/.crab/tests/ and do not affect
normal usage.
    """

    username = ask("Username: ")
    password = ask("Password: ") {|q| q.echo = false }
    project = ask("Project to test against: ")

    dot_crab = File.expand_path("~/.crab/tests")
    FileUtils.mkdir_p dot_crab

    File.open(File.join(dot_crab, 'credentials'), 'w') do |file|
      file.puts username
      file.puts password
    end

    File.open(File.join(dot_crab, 'project'), 'w') do |file|
      file.puts project
    end
  end

end
