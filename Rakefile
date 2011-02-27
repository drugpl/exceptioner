require 'bundler/gem_helper'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

ENV["RAILS_ENV"] ||= "test"

task :default => :test

desc "Run tests for core and transports"
task :test => ["core:test", "transports:test"]

namespace :core do
  desc 'Run exceptioner-core unit tests.'
  Rake::TestTask.new(:test) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
end

def each_gem(action, &block)
  Dir[File.join(File.dirname(__FILE__), 'transports/*')].each do |transport_path|
    puts action
    name = File.basename(transport_path)
    block.call(name, transport_path)
  end
end

namespace :transports do
  desc 'Run transports tests'
  task :test do
    errors = []
    each_gem("Running tests...") do |name, path|
      system("cd #{path} && rake test") || errors << name
    end
    puts "Tests failed for #{errors.join(', ')}" unless errors.empty?
  end
end
