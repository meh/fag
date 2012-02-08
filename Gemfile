source :rubygems

# server
gem 'thin'

# misc stuff
gem 'rake'
gem 'json'
gem 'boolean-expression'
gem 'clj'

# database stuff
gem 'data_mapper'
gem 'dm-transactions'
gem 'dm-timestamps'
gem 'dm-types'
gem 'dm-constraints'
gem 'dm-is-versioned'
gem 'dm-unlazy', git: 'git://github.com/meh/dm-unlazy.git'

gem 'dm-sqlite-adapter'

# api stuff
gem 'rack'
gem 'rack_csrf'
gem 'grape', git: 'git://github.com/intridea/grape.git'

group :development do
	gem 'awesome_print'
	gem 'ripl'
	gem 'ripl-multi_line'
	gem 'ripl-color_error'
	gem 'ripl-auto_indent'

	unless RUBY_ENGINE == 'rbx'
		gem 'ruby-prof'
	end
end
