# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks if Rake::Task.tasks.empty?
KnapsackPro.load_tasks if defined?(KnapsackPro)

require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.since_tag = 'v0.13'
  config.future_release = 'v0.14'
  config.base = "#{Rails.root}/CHANGELOG.md"
  config.token = "41e382c3fa6094e7ba786b243b766ba5190ec23f"
  #config.max_issues = 5
end