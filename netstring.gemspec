# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "netstring"
  s.version     = "0.0.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James McKinney"]
  s.homepage    = "http://github.com/jpmckinney/netstring"
  s.summary     = %q{A netstring parser and emitter}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('coveralls')
  s.add_development_dependency('json', '~> 1.8') # to silence coveralls warning
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.1')
end
