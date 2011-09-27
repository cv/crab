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
    test_project = ask("Name of the project in Rally to be used for tests: ")

    dot_crab = File.expand_path("~/.crab")
    FileUtils.mkdir_p dot_crab
    File.open(File.join(dot_crab, 'test_project'), 'w') do |file|
      file.puts test_project
    end
  end

end
