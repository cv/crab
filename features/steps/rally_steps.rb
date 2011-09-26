Given /^I am logged out$/ do
end

Given /^an instance of Rally$/ do
end

Given /^Rally has a story with ID "([^"]*)"$/ do |arg1|
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
