# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crab/version"

Gem::Specification.new do |s|
  s.name        = "crab"
  s.version     = Crab::VERSION
  s.authors     = ["Carlos Villela"]
  s.email       = ["cvillela@thoughtworks.com"]
  s.homepage    = "http://github.com/cv/crab"
  s.summary     = %q{Cucumber-Rally Bridge}
  s.description = %q{CRaB is a bridge between Cucumber and Rally}

  s.rubyforge_project = "crab"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'aruba'
  s.add_development_dependency 'cucumber'

  s.add_dependency 'gherkin'
  s.add_dependency 'rally_rest_api'
  s.add_dependency 'highline'
  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_dependency 'sanitize'
  s.add_dependency 'trollop'
end
