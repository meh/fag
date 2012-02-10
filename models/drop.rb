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
	include Fag::Versioned
	include Fag::Metadata

	property :id, Serial

	property :title, String

	property :content, Text, required: true

	%w[create update].each {|callback|
		after callback.to_sym do
			Flow.all(drops: { id: id }).each {|flow|
				flow.update(updated_at: updated_at)
			}
		end
	}

	serialize_as do
		{
			id: id,

			author:  author.to_hash,
			content: content,

			created_at: created_at,
			updated_at: updated_at
		}
	end
end

end
