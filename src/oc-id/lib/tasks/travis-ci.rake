# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'

  namespace :travis do
    desc 'Run all specs in except for the request specs'
    RSpec::Core::RakeTask.new(ci: ['assets:precompile', :environment]) do |task|
      ENV['RAILS_ENV'] = 'test'
      task.pattern = FileList['spec/**/*_spec.rb'].exclude('spec/requests/**/*_spec.rb')
    end
  end
rescue LoadError
  # In production, we `bundle config set --local without development test`, so RSpec is not
  # included. Whenever you run a rake task or load the app it loads all of the
  # tasks in lib/tasks, so this will fail in those cases. We don't need this
  # task in those cases, so just fail gracefully and print a warning.
  warn 'RSpec is not available in this environment. Not loading travis:ci Rake task.'
end
