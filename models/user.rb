#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Fag

class User
	include DataMapper::Resource
	include Fag::Serializable

	def self.get (id)
		super(id) || first(name: id)
	end

	property :id, Serial
	property :name, String

	def =~ (other)
		return false if other.is_a?(Anonymous)

		if other.is_a?(User)
			id == other.id
		elsif other.is_a?(Integer)
			id == other
		elsif other.is_a?(String)
			name == other
		end
	end

	def flows
		Flow.all(author_name: name, author_anonymous: false)
	end

	def drops
		Drop.all(author_name: name, author_anonymous: false)
	end

	serialize_as do
		{ id: id, name: name }
	end
end

end
