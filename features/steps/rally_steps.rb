require 'rally_rest_api'

Given /^I am logged out$/ do
end

Given /^an instance of Rally$/ do
end

Given /^Rally has a story with ID "([^"]*)"$/ do |arg1|
end

Then /^the user's home directory should have a file named "([^"]*)"$/ do |file|
  File.exists? File.expand_path("~/#{file}")
end

def get_rally_credentials
  username, password = File.read(File.join(File.dirname(__FILE__), '..', '..', '.rally_credentials')).split(/\n/)
  [ username, password ]
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
    Given I am logged out
    When I run `crab login -u #{username} -p #{password}`
    Then the output should contain "Logged in as #{username}"
  }
end

Then /^a file named "([^"]*)" in the user's home directory should exist$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

def get_rally
  username, password = get_rally_credentials
  @rally = RallyRestAPI.new :username => username, :password => password
end

def get_story(story_id)
  get_rally.find(:hierarchical_requirement, :fetch => true) { equal :formatted_i_d, story_id }.first
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
  FileUtils.rm_rf ".rally_project"
end
