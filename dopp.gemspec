# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dopp/const'

Gem::Specification.new do |spec|
  spec.name          = 'dopp'
  spec.version       = Dopp::VERSION
  spec.authors       = ['srtkkou']
  spec.email         = ['srtkkou@outlook.jp']

  spec.summary       = 'PDF generation library.'
  spec.description   = 'PDF generation library which can ' \
    'treat Japanese texts properly.'
  spec.homepage      = 'https://github.com/srtkkou/dopp'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or
  # delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   # TODO: Set to 'http://mygemserver.com'
  #   spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  #
  #   spec.metadata['homepage_uri'] = spec.homepage
  #
  #   # TODO: Put your gem's public repo URL here.
  #   spec.metadata['source_code_uri'] = ''
  #
  #   # TODO: Put your gem's CHANGELOG.md URL here.
  #   spec.metadata['changelog_uri'] = ''
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that
  # have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) do |f|
    File.basename(f)
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 12.3.3'
end
