# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner"
  s.version     = Exceptioner::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki"]
  s.email       = ["michal.lomnicki@gmail.com"]
  s.homepage    = "https://github.com/mlomnicki/exceptioner"
  s.summary     = "Stay notified of exceptions raised by your application. Choose from various notification methods like Email, Jabber or IRC"
  s.description = "Exceptioner is meant to be for hoptoad, exception_notification or getexceptional. It's fully customizable and works with each kind of ruby application"

  s.rubyforge_project = "exceptioner"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("mail", ["~> 2.2"])
  s.add_dependency("xmpp4r", ["~> 0.5"])
  s.add_dependency("isaac", ["~> 0.2.6"])
  s.add_dependency("redmine_client")

  s.add_development_dependency("rack")
  s.add_development_dependency("mocha")
end
