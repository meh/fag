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

class Drop
	include DataMapper::Resource
	include Fag::Authored
	include Fag::Serializable

	property :id, Serial
	
	belongs_to :flow

	serialize_as do
		{
			id: id, flow: flow.to_json, author: author.to_json,
			created_at: created_at, updated_at: updated_at
		}
	end
end

end
