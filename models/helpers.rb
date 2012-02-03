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

module Serializable
	def self.included (klass)
		class << klass
			def serialize_as (&block)
				define_method :serializable_hash, &block
				define_method :to_hash, &block
			end
		end
	end
end

module Authored
	def self.included (klass)
		klass.instance_eval {
			property :author_name, DataMapper::Property::String, required: false
			property :author_id,  DataMapper::Property::Integer, required: false

			property :created_at, DataMapper::Property::DateTime
			property :updated_at, DataMapper::Property::DateTime
		}
	end

	def anonymous?; author_id.nil?; end

	def author
		anonymous? ? Anonymous.new(author_name) : User.get(author_id)
	end
end

module Versioned
	def self.included (klass)
		klass.instance_eval {
			is_versioned on: :updated_at
		}
	end
end

end
