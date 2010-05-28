require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = 'mascut'
    gem.summary     = 'instant comet-like server in order to debug web pages'
    gem.description = 'instant comet-like server in order to debug web pages'
    gem.email       = 'okitakunio@gmail.com'
    gem.homepage    = 'http://github.com/okitan/mascut'
    gem.authors     = %w[ okitan ]

    gem.add_dependency 'haml', '>= 3.0.6'
    
    gem.add_development_dependency 'rr', '>= 0.10.11'
    gem.add_development_dependency 'rspec', '>= 1.3.0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "mascut #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
