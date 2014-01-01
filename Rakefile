require 'rubocop'

namespace :metrics do
  task :rubocop do
    desc 'Run RuboCop on the lib directory'

    Rubocop::CLI.new.run(%W[lib])
  end
end