
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rlepton/version'

Gem::Specification.new do |spec|
  spec.name          = 'rlepton'
  spec.version       = RLepton::VERSION
  spec.authors       = ['Stuart Harland']
  spec.email         = ['essjayhch@gmail.com']

  spec.summary       = 'Ruby Bindings for the dropbox Lepton compression tool'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com/essjayhch/rlepton'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mimemagic'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
