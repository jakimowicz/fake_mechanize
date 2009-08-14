require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fake_mechanize"
    gem.summary = %Q{toolset for offline unit tests on mechanize, like httpmock}
    gem.email = "fabien@jakimowicz.com"
    gem.homepage = "http://github.com/jakimowicz/fake_mechanize"
    gem.authors = ["Fabien Jakimowicz"]
    gem.rubyforge_project = "fake-mechanize"
    gem.add_dependency 'mechanize'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

desc "build rdoc using hanna theme"
task :rdoc do
  `rm -rf rdoc && rdoc --op=rdoc --title=FakeMechanize --main=README.rdoc --format=darkfish LICENSE README* lib/**/*.rb`
end