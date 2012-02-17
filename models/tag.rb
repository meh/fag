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

	def self.get (what)
		what = what.to_s

		if what.integer?
			super(what.to_i)
		else
			first(name: what)
		end
	end

	property :id, Serial

	property :name, String, unique: true, required: true

	def for_flows
		FlowTag
	end

	def for_floats
		FloatTag
	end

	def flows
		Flow.all(id: for_flows.all(tag_id: id).unlazy.map(&:flow_id))
	end

	def count_flows
		for_flows.count(tag_id: id)
	end

	def floats
		Float.all(id: for_floats.all(tag_id: id).unlazy.map(&:float_id))
	end

	def count_floats
		for_floats.count(tag_id: id)
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
