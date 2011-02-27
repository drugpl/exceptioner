# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-mail/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-mail"
  s.version     = Exceptioner::Mail::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki"]
  s.email       = ["michal.lomnicki@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{SMTP transport for exceptioner}
  s.description = %q{Delivers exceptioner via e-mail}

  s.rubyforge_project = "exceptioner-mail"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("mail", ["~> 2.2"])

  s.add_development_dependency("mocha")
  s.add_development_dependency("rake")
end
