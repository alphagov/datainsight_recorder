# -*- encoding: utf-8 -*-
require File.expand_path('../lib/datainsight_recorder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["GOV.UK Dev"]
  gem.email         = %w(govuk-dev@digital.cabinet-office.gov.uk)
  gem.description   = "helper for implementing Data Insight Recorders"
  gem.summary       = "helper for implementing Data Insight Recorders"
  gem.homepage      = "https://github.com/alphagov/datainsight_recorder"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datainsight_recorder"
  gem.require_paths = %w(lib)
  gem.version       = DataInsight::Recorder::VERSION

  gem.add_dependency "bunny"
  gem.add_dependency "datainsight_logging"
  gem.add_dependency "data_mapper", "1.2.0"
  gem.add_dependency "dm-mysql-adapter", "1.2.0"
  gem.add_dependency "tzinfo", "~> 0.3.37"

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("simplecov")
  gem.add_development_dependency("gemfury")
  gem.add_development_dependency("gem_publisher", "~> 1.2.0")
  gem.add_development_dependency("dm-sqlite-adapter")

end
