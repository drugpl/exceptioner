require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "exceptioner"
    gem.summary = %Q{Be notified about exceptions by various transports Email, Jabber, RSS. Choose the option you want}
    gem.description = %Q{The most common use is to use Exceptioner as rack middleware and send notifications when an exception occur in you web application. It may be used with Rails, Sinatra or any other rack citizen. 
      Exceptioner may be also used with any ruby code you want. Just configure delivery methods and don't miss any exception.}
    gem.email = "michal@lomnicki.com.pl"
    gem.homepage = "http://github.com/mlomnicki/exceptioner"
    gem.authors = ["Michał Łomnicki"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "mail", "~> 2.2"
    gem.add_dependency "xmpp4r", "~> 0.5"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "exceptioner #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
