require 'crab/version'
require 'rubygems'
require 'bundler/setup'

# common dependencies
require 'active_support/all'
require 'fileutils'
require 'gherkin'
require 'gherkin/i18n'
require 'gherkin/formatter/pretty_formatter'
require 'highline/import'
require 'rally_rest_api'
require 'trollop'
require 'tempfile'

# internals
require 'crab/logging'
require 'crab/utilities'
require 'crab/rally'
require 'crab/story'
require 'crab/testcase'
require 'crab/cucumber_to_rally_adapter'
require 'crab/rally_to_cucumber_adapter'

# cucumber support
require 'crab/cucumber_feature'
require 'crab/cucumber_scenario'

# commands
require 'crab/commands'
Dir[File.dirname(__FILE__) + '/crab/commands/**/*.rb'].sort.each do |file|
  require file
end

module Crab
end
