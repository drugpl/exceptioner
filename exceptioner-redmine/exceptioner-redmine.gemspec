# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-redmine/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-redmine"
  s.version     = Exceptioner::Redmine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Darek Gertych"]
  s.email       = ["dariusz.gertych@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{Exceptioner-Redmine integration}
  s.description = %q{New exceptions automatically create redmine issues}

  s.rubyforge_project = "exceptioner-redmine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activeresource"

  eval File.read(File.join(File.dirname(__FILE__), '../development_dependencies.rb'))
end
