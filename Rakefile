require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks
Bundler.setup

ENV["RAILS_ENV"] ||= "test"

task :default => :test

desc 'Run Exceptioner unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
