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
				joins, where, names = _expression_to_sql(expression)

				return if names.empty?

				ids = repository.adapter.select(%{
					SELECT DISTINCT fag_floats.id

					FROM fag_floats

					#{joins}

					WHERE #{where}
				}, *names)

				return if ids.empty?

				Float.all(id: ids)
			else
				expression = Boolean::Expression.parse(expression)

				all.select { |f| expression.evaluate(f.tags.map(&:to_s)) }
			end
		end

	private
		def _expression_to_sql (expression)
			expression = Boolean::Expression.parse(expression.downcase)

			joins = String.new
			where = expression.to_s
			names = expression.names

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

				where.gsub!(name, "(_tag_check_#{index}.flow_id IS NOT NULL)")
			}

			return joins, where, names
		end
	end
end

end
