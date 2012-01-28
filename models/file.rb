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

class File
	include DataMapper::Resource
	include Fag::Authored
	include Fag::Serializable
	include Fag::Versioned

	property :id, Serial
	
	property :name,     String
	property :language, String
	property :content,  Text

	has n, :lines

	serialize_as do
		{
			id: id,

			name:     name,
			language: language,
			content:  content,

			lines: lines.all(order: :number.asc).map(&:to_hash)
		}
	end
end

end
