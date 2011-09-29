require "crab/version"

# common dependencies
require 'active_support/all'
require 'fileutils'
require 'gherkin/i18n'
require 'highline/import'
require 'rally_rest_api'
require 'sanitize'
require 'trollop'

# internals
require "crab/utilities"
require "crab/rally"
require "crab/story"
require "crab/testcase"

# cucumber support
require "crab/cucumber_feature"
require "crab/cucumber_scenario"

module Crab
end
