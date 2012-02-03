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
		super(Integer(id)) or fail
	rescue
		first(name: id)
	end

	property :id, Serial

	property :name, String, required: true

	property :password, BCryptHash, required: true

	def =~ (other)
		return false if other.is_a?(Anonymous)

		begin
			other = Integer(other)
		rescue; end

		if other.is_a?(User)
			id == other.id
		elsif other.is_a?(Integer)
			id == other
		elsif other.is_a?(String)
			name == other
		end
	end

	def flows
		Flow.all(author_id: id)
	end

	def drops
		Drop.all(author_id: id)
	end

	property :powers, Object, default: {}
	property :god, Boolean, default: false

	def is_god?
		god
	end

	def can (what)
		is_god? || powers[what.to_s.downcase]
	end

	def can? (what)
		is_god? || !!can(what)
	end

	def cannot? (what)
		!is_god? || !can(what)
	end

	def can! (what, value=true)
		update(powers: powers.tap { |p| p[what.to_s.downcase] = value })
	end

	def cannot! (what)
		update(powers: powers.tap { |p| p.delete(what.to_s.downcase) })
	end

	serialize_as do
		{
			id: id,
			
			name: name
		}
	end
end

end
