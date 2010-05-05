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
            tags << "#{tag.output :link, tagFormat} "
        }

        return templatify(wholeFormat, binding)
    end

    def get_tags
        result = String.new

        UsedTag.find(:all, :conditions => ['flow_id = ?', self.id], :include => :tag).each {|tag|
            result << " \"#{tag.name}\""
        }

        return result[1, result.length]
    end
end
