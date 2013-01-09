# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "letterpress/version"

Gem::Specification.new do |s|
  s.name        = "letterpress"
  s.version     = Letterpress::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Jones"]
  s.email       = ["unixmonkey1@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gem to model a Letterpress game board and suggest or simulate moves}
  s.description = %q{This is a fun project to see how well I can simulate the state of a Letterpress game board}

  s.rubyforge_project = "letterpress"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
