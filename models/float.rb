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

class Float
	include DataMapper::Resource
	include Fag::Authored
	include Fag::Serializable

	property :id, Serial

	has n, :files, through: Resource, constraint: :destroy

	serialize_as do
		{
			id: id,

			files: files.map(&:to_hash)
		}
	end
end

end
