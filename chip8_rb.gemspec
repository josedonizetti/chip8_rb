# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chip8_rb/version'

Gem::Specification.new do |spec|
  spec.name          = "chip8_rb"
  spec.version       = Chip8Rb::VERSION
  spec.authors       = ["Jose Donizetti"]
  spec.email         = ["jdbjunior@gmail.com"]
  spec.summary       = %q{chip8 interpreter}
  spec.description   = %q{chip8 interpreter}
  spec.homepage      = "https://github.com/josedonizetti/chip8_rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6.rc2"
  spec.add_development_dependency "rake"
end
