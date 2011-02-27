# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-http/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-http"
  s.version     = Exceptioner::Http::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paweł Pacana"]
  s.email       = ["pawel.pacana@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{HTTP transport for exceptioner}
  s.description = %q{Delivers exceptioner via HTTP protocol}

  s.rubyforge_project = "exceptioner-http"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("json")
  s.add_development_dependency("webmock")

  s.add_development_dependency("mocha")
  s.add_development_dependency("rake")
end
