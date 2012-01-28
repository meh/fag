#! /usr/bin/env ruby
require 'rake'

task :default => :start

task :start do
	sh 'bundle exec thin --debug start -R config.ru'
end

task :setup do
	sh 'bundle install'
	sh 'bundle exec rake db:setup'
end

namespace :db do
	task :include do
		$:.unshift(File.dirname(__FILE__))
		require 'environment'
	end

	task :migrate => :include do
		DataMapper::auto_migrate!
	end

	task :setup => :migrate
end
