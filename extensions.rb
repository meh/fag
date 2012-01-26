#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'json'
require 'with'

module Fag

module Serializable
	def self.included (klass)
		klass.instance_eval {
			define_singleton_method :serialize_as do |&block|
				define_method :to_json, &block
				define_method :serializable_hash, &block
			end
		}
	end
end

module Authored
	def self.included (klass)
		klass.instance_eval {
			property :author_name, String, default: 'Anonymous'
			property :author_anonymous, Boolean, default: true


			def anonymous?;  author_anonymous;         end
			def anonymous!;  author_anonymous = true;  end
			def registered!; author_anonymous = false; end

			def author
				anonymous? ? Anonymous.new(author_name) : User.get(author_name)
			end

			property :created_at, DateTime
			property :updated_at, DateTime

			is_versioned on: :updated_at
		}
	end
end


end
