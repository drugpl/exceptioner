if Object.const_defined?(:Bundler) && Bundler.const_defined?(:Dsl) && self.kind_of?(Bundler::Dsl)
  group :development do
    gem 'rack'
    gem 'mocha'
    gem 'rake'
    gem 'webmock'
    gem 'contest'
  end
else #gemspec
  s.add_development_dependency("rack")
  s.add_development_dependency("mocha")
  s.add_development_dependency("rake")
  s.add_development_dependency("webmock")
  s.add_development_dependency("contest")
end
