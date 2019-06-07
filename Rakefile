# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks if Rake::Task.tasks.empty?
KnapsackPro.load_tasks if defined?(KnapsackPro)

require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.since_tag = 'v0.18.1'
  config.future_release = 'v0.19'
  config.base = "#{Rails.root}/CHANGELOG.md"
  config.token = Rails.application.secrets.github_changelog_token
  config.max_issues = 1
end
