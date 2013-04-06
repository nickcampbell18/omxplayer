# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omx'

Gem::Specification.new do |gem|
  gem.name          = "omxplayer"
  gem.version       = Omx::VERSION
  gem.authors       = ["Nick Campbell"]
  gem.email         = ["nickcampbell18@gmail.com"]
  gem.description   = %q{Control your Raspberry Pi omxplayer from Ruby using mkfifo}
  gem.summary       = %q{Control your Raspberry Pi omxplayer from Ruby using mkfifo pipes}
  gem.homepage      = "https://github.com/nickcampbell18/omxplayer"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
