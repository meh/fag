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
	include DataMapper::Resource
	include Fag::Serializable
	include Fag::WithMetadata

	property :id, Serial

	property :name, String, unique: true, required: true

	def flows
		Flow.all(id: FlowTag.all(tag_id: id).unlazy.map(&:flow_id))
	end

	def count_flows
		FlowTag.count(tag_id: id)
	end

	def floats
		Float.all(id: FloatTag.all(tag_id: id).unlazy.map(&:float_id))
	end

	def count_floats
		FloatTag.count(tag_id: id)
	end

	serialize_as do
		{
			id: id,
			
			name: name
		}
	end

	def to_s
		name
	end
end

end
