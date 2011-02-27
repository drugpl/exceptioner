require 'bundler/gem_helper'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

ENV["RAILS_ENV"] ||= "test"

task :default => :test

desc "Run tests for core and transports"
task :test => ["core:test", "transports:test"]

module TaskUtils
  extend self

  def run_tests(path)
    system("cd #{path} && rake test")
  end

  def build(path)
    system("cd #{path} && rake build")
  end

  def each_gem(action, paths = all_paths, &block)
    all_paths.each do |path|
      puts action
      name = File.basename(path)
      block.call(name, path)
    end
  end

  def transports_paths
    Dir[File.join(File.dirname(__FILE__), 'transports/*')]
  end

  def core_path
    File.join(File.dirname(__FILE__), 'exceptioner-core')
  end

  def all_paths
    [core_path] + transports_paths
  end

end

namespace :build do
  desc "Builds all gems"
  task :all => :build do
    TaskUtils.each_gem("Building...") do |name, path|
      puts name
      TaskUtils.build(path)
    end
  end
end

namespace :core do
  desc "Run exceptioner-core tests"
  task :test do
    TaskUtils.run_tests(TaskUtils.core_path)
  end
end

namespace :transports do
  desc 'Run transports tests'
  task :test do
    errors = []
    TaskUtils.each_gem("Running transport tests...", TaskUtils.transports_paths) do |name, path|
      TaskUtils.run_tests(path) || errors << name
    end
    puts "Tests failed for #{errors.join(', ')}" unless errors.empty?
  end
end
