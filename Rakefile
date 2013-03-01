# 
# Copyright (c) 2013 by Lifted Studios.  All Rights Reserved.
# 

require 'bundler/gem_tasks'
require 'html/pipeline/cite/version'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  HTML::Pipeline::Cite::VERSION
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

CLEAN.include('.yardoc')
CLOBBER.include('doc', 'pkg')

task :default => [:test, :yard]

desc "Execute all tests"
task :test => [:spec]

Rake::TestTask.new('spec') do |spec|
  spec.libs << 'spec'
  spec.test_files = Dir['spec/**/*_spec.rb']
  # spec.warning = true
end

YARD::Rake::YardocTask.new

desc 'Build gem'
task :build do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

desc 'Create a release build'
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git pull"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

task :install => [:build] do
  sh "gem install pkg/#{gem_file}"
end
