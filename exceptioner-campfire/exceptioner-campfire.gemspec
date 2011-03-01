# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-campfire/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-campfire"
  s.version     = Exceptioner::Campfire::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Łukasz Śliwa"]
  s.email       = ["lukasz.sliwa@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{Campfire transport for exceptioner}
  s.description = %q{Delivers exception notifications to Campfire rooms}

  s.rubyforge_project = "exceptioner-campfire"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("exceptioner-core", ["~> 0.6"]) if ENV['EXCEPTIONER_BUILD']
  s.add_dependency("tinder", ["~> 1.4"])
  s.add_dependency("i18n", ["~> 0.5"])


  eval File.read(File.join(File.dirname(__FILE__), '../development_dependencies.rb'))
end
