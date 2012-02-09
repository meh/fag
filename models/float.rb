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

	has n, :tags, through: Resource, constraint: :destroy

	property :title, String

	has n, :files, through: Resource, constraint: :destroy

	serialize_as do
		{
			id: id,

			title:  title,
			tags:   tags.map(&:to_s),
			author: author.to_hash,

			files: files.map(&:to_hash),

			created_at: created_at,
			updated_at: updated_at
		}
	end

	def add_tag (name)
		return unless tags.count(name: name).zero?

		tags << Tag.first_or_create(name: name)
		tags.save
	end

	def add_tags (*names)
		names.flatten.each { |n| add_tag(n) }
	end

	def delete_tag (name)
		float_tags.all(float_id: id, tag_id: Tag.first(name: name).id).destroy
	end

	def delete_tags (*names)
		names.flatten.each { |n| delete_tag(name) }
	end

	def clean_tags
		float_tags.all(float_id: id).destroy
	end


	class << self
		def find_by_expression (expression)
			if repository.adapter.respond_to? :select
				joins, names, expression = _expression_to_sql(expression)

				return if names.empty?

				ids = repository.adapter.select(%{
					SELECT DISTINCT fag_floats.id

					FROM fag_floats

					#{joins}

					WHERE #{expression}
				}, *names)

				return if ids.empty?

				Float.all(id: ids)
			else
				expression = Boolean::Expression.parse(expression)

				all.select { |f| expression.evaluate(f.tags.map(&:to_s)) }
			end
		end

	private
		def _expression_to_sql (value)
			value.downcase!

			value.gsub!(/(\s+|\))and(\s+|\()/, '\1&&\2')
			value.gsub!(/\s*&&\s*/, ' && ')
			value.gsub!(/(\s+|\))or(\s+|\()/, '\1||\2')
			value.gsub!(/\s*\|\|\s*/, ' || ')
			value.gsub!(/(\A|\s+)not(\s+|\()/, '\1!\2')

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

						FROM fag_float_tags AS _used_tag_#{index}

						INNER JOIN fag_tags AS _tag_#{index}
							ON _used_tag_#{index}.tag_id = _tag_#{index}.id AND _tag_#{index}.name = ?
					) AS _tag_check_#{index}
						ON fag_floats.id = _tag_check_#{index}.flow_id
				}

				name = %{"#{name}"} if name =~ /[\s&!|]/

				expression.gsub!(/([\s()]|\G)!\s*#{Regexp.escape(name)}([\s()]|$)/, "\\1 (_tag_check_#{index}.flow_id IS NULL) \\2")
				expression.gsub!(/([\s()]|\G)#{Regexp.escape(name)}([\s()]|$)/, "\\1 (_tag_check_#{index}.flow_id IS NOT NULL) \\2")
			}

			expression.gsub!(/(\A|[\s()])&&([\s()]|\z)/, '\1 AND \2')
			expression.gsub!(/(\A|[\s()])\|\|([\s()]|\z)/, '\1 OR \2')
			expression.gsub!(/(\A|[\s()])!([\s()]|\z)/, '\1 NOT \2')

			return joins, names, expression
		end
	end
end

end
