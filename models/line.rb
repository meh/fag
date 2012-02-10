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

class Line
	include DataMapper::Resource
	include Fag::Serializable
	include Fag::Metadata

	property :id, Serial

	property :number, Integer, required: true

	belongs_to :file

	has n, :drops, through: Resource, constraint: :destroy

	serialize_as do
		{
			id:   id,
			file: file.id,

			line: number,

			drops: drops.map(&:id)
		}
	end
end

end
