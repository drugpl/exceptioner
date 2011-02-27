# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-irc/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-irc"
  s.version     = Exceptioner::Irc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Piotr Niełacny (LiTE)"]
  s.email       = ["piotr.nielacny@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{IRC transport for exceptioner}
  s.description = %q{Delivers exception notifications to IRC channels}

  s.rubyforge_project = "exceptioner-irc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("isaac", ["~> 0.2.6"])

  eval File.read(File.join(File.dirname(__FILE__), '../../development_dependencies.rb'))
end
