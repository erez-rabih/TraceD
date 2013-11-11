# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traced/version'

Gem::Specification.new do |spec|
  spec.name          = "traced"
  spec.version       = Traced::VERSION
  spec.authors       = ["Erez Rabih"]
  spec.email         = ["erez.rabih@gmail.com"]
  spec.description   = %q{Method tracer for Statsd written in Ruby}
  spec.summary       = %q{TraceD is a small module which enables seamless method tracing for both execution time and execution count}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
