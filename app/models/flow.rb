# == Schema Information
# Schema version: 11
#
# Table name: flows
#
#  id         :integer         not null, primary key
#  stopped    :boolean
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# fag, forums are gay
#
# Copyleft meh. [http://meh.doesntexist.org | meh.ffff@gmail.com]
#
# This file is part of fag.
#
# fag is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fag is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with fag. If not, see <http://www.gnu.org/licenses/>.

class Flow < ActiveRecord::Base
    attr_accessible :closed, :title

    has_many :drops,     :autosave => true, :dependent => :delete_all
    has_many :used_tags, :autosave => true, :dependent => :delete_all

    def add_tags (text, cap=2000)
        once = false

        Tag.parse(text).each {|name|
            if !(tag = Tag.find_by_name(name))
                tag = Tag.new(:name => name)
                tag.save
            end

            if tag.priority.to_i < cap
                next
            end

            self.used_tags << UsedTag.new(:tag => tag, :flow => self)

            once = true
        }

        if !once
            self.add_tags('undefined')
        end
    end

    def self.expression_to_sql (value, avoid=false)
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

        names.each_index {|index|
            joins << %{
                LEFT JOIN (
                    SELECT ____u_t_#{index}.flow_id
                    
                    FROM used_tags AS ____u_t_#{index}
                    
                    INNER JOIN tags AS ____t_#{index}
                        ON ____u_t_#{index}.tag_id = ____t_#{index}.id AND ____t_#{index}.name = ?
                ) AS ____t_i_#{index}
                    ON flows.id = ____t_i_#{index}.flow_id
            }

            if (replace = names[index]).match(/[\s&!|]/)
                replace = %{"#{replace}"}
            end

            expression.gsub!(/([\s()]|\G)!\s*#{Regexp.escape(replace)}([\s()]|$)/, "\\1 (____t_i_#{index}.flow_id IS NULL) \\2")
            expression.gsub!(/([\s()]|\G)#{Regexp.escape(replace)}([\s()]|$)/, "\\1 (____t_i_#{index}.flow_id IS NOT NULL) \\2")
        }

        expression.gsub!(/([\G\s()])&&([\s()\A])/, '\1 AND \2')
        expression.gsub!(/([\G\s()])\|\|([\s()\A])/, '\1 OR \2')
        expression.gsub!(/([\G\s()])!([\s()\A])/, '\1 NOT \2')

        return [joins, names, expression]
    end

    def self.find_by_expression (expression, avoid=false)
        joins, names, expression = self.expression_to_sql(expression, avoid)

        Flow.find_by_sql([%{
            SELECT DISTINCT flows.*
            
            FROM flows

            #{joins}
            
            WHERE #{expression}

            ORDER BY updated_at DESC
        }].concat(names))
    end

    def output (what, *args)
        self.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def output_link
        "<a href='/ocean/flow/#{self.id}'>#{self.output :title}</a>"
    end

    def output_last_post (template='#{at} #{by}')
        drop = self.drops.last

        at = nil
        by = nil

        if drop
            at = drop.created_at
            by = User.output :user, drop
        end

        return templatify(template, binding)
    end

    def output_title
        return ERB::Util.h self.title
    end

    def output_tags (wholeFormat=nil, tagFormat=nil)
        wholeFormat ||= '#{tags}'
        tagFormat   ||= '&quot;<a href="#{url}" class="float #{type}">#{name}</a>&quot;'

        tags = String.new

        self.used_tags.each {|tag|
            puts tag
            tags << "#{tag.output :link, tagFormat} "
        }

        puts ''

        return templatify(wholeFormat, binding)
    end

    def get_tags
        result = String.new

        UsedTag.find(:all, :conditions => ['flow_id = ?', self.id], :include => :tag).each {|tag|
            result << " &quot;#{tag.name}&quot;"
        }

        return result[1, result.length]
    end
end
