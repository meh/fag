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
	include Fag::Metadata

	def self.get (what)
		what = what.to_s

		if what.integer?
			super(what.to_i)
		else
			first(name: what)
		end
	end

	def =~ (other)
		return false if other.is_a?(Anonymous)

		if other.is_a?(User)
			id == other.id
		else
			other = other.to_s

			if other.integer?
				id == other.to_i
			else
				name == other
			end
		end
	end

	property :id, Serial

	property :name, String, unique: true, required: true

	property :password, BCryptHash, required: true

	property :email, String, unique: true

	validates_format_of :email, as: :email_address

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
