# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-jabber/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-jabber"
  s.version     = Exceptioner::Jabber::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki", "Jan Dudek"]
  s.email       = ["michal.lomnicki@gmail.com", "jd@jandudek.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{XMPP transport for exceptioner}
  s.description = %q{Delivers exceptioner via jabber}

  s.rubyforge_project = "exceptioner-jabber"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("exceptioner-core", ["~> 0.6"]) if ENV['EXCEPTIONER_BUILD']
  s.add_dependency("xmpp4r", ["~> 0.5"])

  eval File.read(File.join(File.dirname(__FILE__), '../development_dependencies.rb'))
end
