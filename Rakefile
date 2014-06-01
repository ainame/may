require "bundler/gem_tasks"

task :local do
  sh 'gem build may.gemspec'
  latest_version_gem = Dir['may-*.gem'].last
  sh "gem install #{latest_version_gem}"
end
