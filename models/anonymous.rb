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

class Anonymous
	extend Serializable

	attr_reader :name

	def initialize (name)
		@name = name
	end

	def flows
		[]
	end

	def drops
		[]
	end

	serialize_as do
		{ name: name }
	end
end

end
