# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imdb/parser/version'

Gem::Specification.new do |spec|
  spec.name          = "imdb-parser"
  spec.version       = IMDB::Parser::VERSION
  spec.authors       = ["Ben Olive"]
  spec.email         = ["sionide21@gmail.com"]
  spec.description   = %q{Parses the `actors.list` and `actresses.list` files from IMDB's alternate interfaces page.}
  spec.summary       = %q{A parser for the IMDB actor and actress files.}
  spec.homepage      = "https://github.com/sionide21/imdb-actors"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
