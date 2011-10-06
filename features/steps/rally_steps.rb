require 'rally_rest_api'

def get_rally_credentials
  file = File.expand_path("~/.crab/tests/credentials")

  if File.exists? file
    username, password = File.read(file).split(/\n/)
    [ username, password ]
  else
    raise "Please run rake cucumber:setup first"
  end
end

def get_rally
  username, password = get_rally_credentials
  @rally = RallyRestAPI.new :username => username, :password => password
end

def get_story(story_id)
  get_rally.find(:hierarchical_requirement, :fetch => true) { equal :formatted_i_d, story_id }.first
end

def get_project
  project_file = File.expand_path("~/.crab/tests/project")
  if File.exists? project_file
    File.read(project_file).strip
  else
    raise "Looks like your test project isn't set up. Please run 'rake cucumber:setup'"
  end
end

Then /^I should see a usage screen$/ do
  Then "the output should contain:", <<-TEXT
Usage: crab <command> [options*]

crab version #{Crab::VERSION}: A Cucumber-Rally bridge

  Available commands:

       help  Show this help text
  iteration  Manipulate iterations
      login  Persistently authenticate user with Rally
     logout  Remove stored Rally credentials
    project  Persistently select project to work with in Rally
    release  Manipulate releases
      story  Manipulate stories
   testcase  Manipulate test cases

  --version, -v:   Print version and exit
     --help, -h:   Show this message
  TEXT
end

Then /^the user's home directory should have a file named "([^"]*)"$/ do |file|
  File.exists? File.expand_path("~/#{file}")
end

When /^I type my username$/ do
  When %Q{I type "#{get_rally_credentials.first}"}
end

When /^I type my password$/ do
  When %Q{I type "#{get_rally_credentials.last}"}
end

Given /^I am logged in$/ do
  username, password = get_rally_credentials
  steps %Q{
    When I run `crab login -u #{username} -p #{password}`
    Then the output should contain "Credentials stored for #{username}"
  }
end

Then /^a file named "([^"]*)" in the user's home directory should exist$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the story ([A-Z]{2}\d+) should be blocked$/ do |story_id|
  story = get_story(story_id)
  story.blocked.should == "true"
end

Then /^the story ([A-Z]{2}\d+) should be unblocked$/ do |story_id|
  story = get_story(story_id)
  story.blocked.should == "false"
end

Then /^the story ([A-Z]{2}\d+) should be in iteration "([^"]*)"$/ do |story_id, iteration_name|
  story = get_story story_id
  story.iteration.name.should == iteration_name
end

Then /^the story ([A-Z]{2}\d+) should be in release "([^"]*)"$/ do |story_id, release_name|
  story = get_story story_id
  story.release.name.should == release_name
end

Then /^the story ([A-Z]{2}\d+) should have ([A-Z]{2}\d+) as its parent$/ do |child, parent|
  story = get_story child
  story.parent.should_not be_nil
  story.parent.formatted_i_d.should == parent
end

Given /^no project is selected$/ do
  Given 'I run `rm -rf ".crab/project"`'
  Then 'the exit status should be 0'
end

Given /^I have selected the project "([^"]*)"$/ do |project|
  unless get_project == project
    steps %Q{
      When I run `crab project #{project}`
      Then the exit status should be 0
    }
  end
end

Given /^I have selected my test project$/ do
  When %{I run `crab project "#{get_project}"`}
  Then %{the exit status should be 0}
end

When /^I select my test project$/ do
  When %{I run `crab project "#{get_project}"`}
  Then %{the exit status should be 0}
end

Then /^the output should be the name of my test project$/ do
  Then %Q{the output should contain "#{get_project}"}
end
