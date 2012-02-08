#! /usr/bin/env ruby
require 'rake'

task :default => :start

task :start do
	sh "bundle exec thin --port #{ENV['FAG_PORT'] || 3000} #{'--debug' if ENV['FAG_DEVELOPMENT']} start -R config.ru"
end

task :console do
	sh 'bundle exec ripl -I. -renvironment'
end

task :terminal

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

	task :setup => :migrate do
		Fag::User.create(name: 'root', password: 'root', god: true)
	end

	task :test => :setup do
		names    = %w[meh yawn bronsa tilde shura one joxer ccjh jcjh Gaggo]
		titles   = %w[noob help program source fail compile debug syntax]
		tags     = %w[random c++ c java ruby javascript format:markdown format:bbcode .net]
		contents = %w[i like turtles cocks forever alone omg hax shit nigger]

		Fag::Flow.transaction do
			1.upto 50 do |n|
				puts "Creating flow #{n}"

				flow = Fag::Flow.create(title: titles.shuffle.select { rand(100) < 70 }.join(' '), author_name: names.shuffle.first)
				flow.add_tags(tags.select { rand(100) < 70 })

				max = rand(50)

				puts "Creating #{max} drops for flow #{n}"

				1.upto max do |m|
					drop = flow.drops.create(author_name: names.shuffle.first, content: (contents * 1000).select { rand(100) < 70 }.join(' '))
				end
			end
		end
	end
end
