# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crab/version"

Gem::Specification.new do |s|
  s.name        = "crab"
  s.version     = Crab::VERSION
  s.authors     = ["Carlos Villela"]
  s.email       = ["cvillela@thoughtworks.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "crab"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.executables = 'crab'

  s.add_development_dependency 'aruba'

  s.add_dependency 'aruba'
  s.add_dependency 'cucumber'
  s.add_dependency 'rally_rest_api'
  s.add_dependency 'highline'
  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_dependency 'sanitize'
  s.add_dependency 'trollop'
end
