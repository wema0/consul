# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks if Rake::Task.tasks.empty?
KnapsackPro.load_tasks if defined?(KnapsackPro)

require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
<<<<<<< HEAD
  config.since_tag = 'v0.14'
  config.future_release = 'v0.15'
  config.base = "#{Rails.root}/CHANGELOG.md"
  config.token = "e85e3e31f40e5cfa596507265429a06ffddd63a6"
  config.max_issues = 1
=======
  config.since_tag = 'v0.13'
  config.future_release = 'v0.14'
  config.base = "#{Rails.root}/CHANGELOG.md"
  config.token = "41e382c3fa6094e7ba786b243b766ba5190ec23f"
  #config.max_issues = 5
>>>>>>> changelog gem configuration
end