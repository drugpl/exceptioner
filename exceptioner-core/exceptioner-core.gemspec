# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner-core/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-core"
  s.version     = Exceptioner::Core::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki", "Jan Dudek", "Piotr Niełacny", "Paweł Pacana", "Staszek Kolarzowski"]
  s.email       = ["michal.lomnicki@gmail.com", "jd@jandudek.com", "piotr.nielacny@gmail.com", "pawel.pacana@gmail.com", "stanislaw.kolarzowski@gmail.com"]
  s.homepage    = "https://github.com/drugpl/exceptioner"
  s.summary     = %q{Core functionality of exceptioner}

  s.rubyforge_project = "exceptioner-core"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("valuable", ["~> 0.8.5"])

  eval File.read(File.join(File.dirname(__FILE__), '../development_dependencies.rb'))
end
