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

class Flow
	include DataMapper::Resource
	include Fag::Authored
	include Fag::Serializable

	property :id, Serial

	has n, :tags, through: Resource, constraint: :destroy

	property :title, String

	has n, :drops, through: Resource, constraint: :destroy

	serialize_as do
		{
			id: id,

			title:  title,
			tags:   tags.map(&:to_s),
			author: author.to_hash,

			drops: drops.map(&:to_hash),

			created_at: created_at,
			updated_at: updated_at
		}
	end

	class << self
		def find_by_expression (expression)
			joins, names, expression = _expression_to_sql(expression)

			return [] if expression.empty?

			repository.adapter.select(%{
				SELECT DISTINCT fag_flows.id

				FROM fag_flows

				#{joins}

				WHERE #{expression}
			}, *names).map { |id| Flow.get(id) }
		end

	private
		def _expression_to_sql (value)
			value.downcase!
			value.gsub!(/(\s+and\s+|\s*&&\s*)/i, ' && ')
			value.gsub!(/(\s+or\s+|\s*\|\|\s*)/i, ' || ')
			value.gsub!(/(\s+not\s+|\s*!\s*)/i, ' !')
			value.gsub!(/\(\s*!/, '(!')

			joins      = String.new
			names      = []
			expression = value.clone

			expression.scan(/(("(([^\\"]|\\.)*)")|([^\s&!|()]+))/) {|match|
				names.push((match[2] || match[4]).downcase)
			}

			names.compact!
			names.uniq!

			names.each_with_index {|name, index|
				joins << %{
					LEFT JOIN (
						SELECT _used_tag_#{index}.flow_id

						FROM fag_flow_tags AS _used_tag_#{index}

						INNER JOIN fag_tags AS _tag_#{index}
							ON _used_tag_#{index}.tag_id = _tag_#{index}.id AND _tag_#{index}.name = ?
					) AS _tag_check_#{index}
						ON fag_flows.id = _tag_check_#{index}.flow_id
				}

				name = %{"#{name}"} if name =~ /[\s&!|]/

				expression.gsub!(/([\s()]|\G)!\s*#{Regexp.escape(name)}([\s()]|$)/, "\\1 (_tag_check_#{index}.flow_id IS NULL) \\2")
				expression.gsub!(/([\s()]|\G)#{Regexp.escape(name)}([\s()]|$)/, "\\1 (_tag_check_#{index}.flow_id IS NOT NULL) \\2")
			}

			expression.gsub!(/([\G\s()])&&([\s()\A])/, '\1 AND \2')
			expression.gsub!(/([\G\s()])\|\|([\s()\A])/, '\1 OR \2')
			expression.gsub!(/([\G\s()])!([\s()\A])/, '\1 NOT \2')

			return joins, names, expression
		end
	end
end

end
