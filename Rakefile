require 'rubocop'
require 'rspec/core/rake_task'

namespace :metrics do
  desc 'Run RuboCop on the lib directory'
  task :rubocop do
    Rubocop::CLI.new.run(%W[lib])
  end
end

desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/{unit,integration}/{,/*/**}/*_spec.rb'
end