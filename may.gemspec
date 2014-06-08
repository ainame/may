# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'may/version'

Gem::Specification.new do |spec|
  spec.name          = "may"
  spec.version       = May::VERSION
  spec.authors       = ["ainame"]
  spec.email         = ["s.namai.2012@gmail.com"]
  spec.summary       = %q{may is a CLI tools for generating Objective-C based class files to a Xcode project.}
  spec.description   = %q{may is a CLI tools for generating Objective-C based class files to a Xcode project. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2"
  spec.add_development_dependency "pry-byebug", '~> 1.3'
  spec.add_runtime_dependency "tilt", "~> 2.0"
  spec.add_runtime_dependency "xcodeproj", "~> 0.17"
  spec.add_runtime_dependency "claide", "~> 0.6"
end
