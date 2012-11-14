require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ["--format documentation"]
end

require "gem_publisher"
task :publish_gem do |task|
  gem = GemPublisher.publish_if_updated("datainsight_recorder.gemspec", :gemfury)
  puts "Published #{gem}" if gem
end

task :default => :test