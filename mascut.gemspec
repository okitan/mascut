# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'mascut'

Gem::Specification.new do |s|
  s.name        = "mascut"
  s.version     = Mascut::VERSION
  s.authors     = ["okitan"]
  s.email       = ["okitakunio@gmail.com"]
  s.homepage    = ""
  s.summary     = 'instant comet-like server in order to debug web pages'
  s.description = 'instant comet-like server in order to debug web pages'

  s.rubyforge_project = "mascut"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  [ [ 'haml', '~> 3.0' ],
    [ 'rack' ],
  ].each do |gem, version|
    s.add_dependency gem, version
  end

  [ [ 'rr',    '~> 1.0' ],
    [ 'rspec', '~> 2.7' ],
  ].each do |gem, version|
    s.add_development_dependency gem, version
  end
end
