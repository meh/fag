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

class Tag
	extend  Serializable
	include DataMapper::Resource

	property :id, Serial

	property :name, String

	def flows
		Flow.find_by_expression(name)
	end

	serialize_as do
		name
	end
end

end
