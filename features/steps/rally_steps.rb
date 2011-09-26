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
  username, password = nil, nil
  File.open(File.join(File.dirname(__FILE__), '..', '..', '.rally_credentials')) do |credentials|
    username, password = credentials.gets, credentials.gets
  end
  [ username, password ]
end

When /^I type my username$/ do
  When %Q{I type "#{get_rally_credentials.first}"}
end

When /^I type my password$/ do
  When %Q{I type "#{get_rally_credentials.last}"}
end

Given /^I am logged in$/ do
  steps %Q{
    Given I am logged out
    When I run `crab login` interactively
    When I type my username
    When I type my password
    Then the exit status should be 0
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

Then /^the story (\w\w\d+) should be blocked$/ do |story_id|
  story = get_story(story_id)
  story.blocked.should == true
end

Then /^the story (\w\w\d+) should not be blocked$/ do |story_id|
  story = get_story(story_id)
  story.blocked.should == false
end

Then /^the story (\w\w\d+) should be in iteration "([^"]*)"$/ do |story_id, iteration_name|
  story = get_story story_id
  story.iteration.name.should == iteration_name
end

