Gem::Specification.new do |gem|
  gem.name = 'workday'
  gem.version = '0.9.6'

  gem.authors = ['Jay Wagnon']
  gem.email = ['jay.wagnon@octanner.com']

  gem.description = %q{Gem for accessing Workday's API.}
  gem.summary = gem.description
  gem.homepage = 'https://github.com/octanner/workday'

  gem.files = Dir.glob('lib/**/*')
  gem.require_paths = %w[lib]

  gem.test_files = %w[]

  gem.add_dependency 'savon', '~> 2.2.0'
  gem.add_dependency 'virtus', '~> 0.5.5'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'virtus-rspec'
  gem.add_development_dependency 'excon'
end
