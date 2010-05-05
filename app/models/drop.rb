# == Schema Information
# Schema version: 11
#
# Table name: drops
#
#  id         :integer         not null, primary key
#  flow_id    :integer
#  user_id    :integer
#  name       :string(255)
#  content    :text
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

require 'uri'

class Drop < ActiveRecord::Base
    include ThemesHelper

    attr_accessible :name, :title, :content

    belongs_to :flow
    belongs_to :user

    def self.parse (content, user)
        content.gsub!(/\r/, '')

        content.scan(/^((-)+\s*([^\s\-]+?)\s*(-)+\n(.+?)\n(-)+$)/m).uniq.each {|match|
            code = Code.new(:language => match[2], :content => match[4])

            if user.is_a?(User)
                code.user = user
            else
                code.name = user
            end

            code.save

            content.gsub!(/#{Regexp.escape(match[0])}/, "< #{code.path}")
        }

        return content
    end

    def self.filter (content)
        Drop.new.output :content, content
    end

    def output (what, *args)
        self.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def output_content (text=nil)
        content = (text ? text : self.content).clone
        
        content.gsub!(/</, '&lt;')
        content.gsub!(/>/, '&gt;')

        content.scan(/("([^"]+)":(\w+:\/\/[^\s]+))/).uniq.each {|match|
            if match[1].strip.empty?
                next
            end

            content.gsub!(/#{Regexp.escape(match[0])}/, "<a href='#{SyntaxHighlighter::Language.escape(match[2])}' #{'target="_blank"' if !match[2].match(/http:\/\/#{Regexp.escape(DOMAIN)}/)}>#{SyntaxHighlighter::Language.escape(match[1])}</a>")
        }

        content.gsub!('"', '&quot;')
        content.gsub!("\n", '<br/>')

        content.scan(%r{(\G|<br/>)(&lt; (http://#{DOMAIN})?/code(s)?/(\d+)(<br/>)?)}).uniq.each {|match|
            content.gsub!(/#{Regexp.escape(match[1])}/, ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => "#{theme_path true}/codes/show", :locals => { :code => (Code.find(match[4]) rescue nil), :inself => true }).strip)
        }

        URI.extract(content).uniq.each {|uri|
            if !uri.match(%r{^\w+://})
                next
            end

            content.gsub!(/#{Regexp.escape(uri)}/, "<a href='#{SyntaxHighlighter::Language.escape(uri)}' #{'target="_blank"' if !uri.match(/http:\/\/#{Regexp.escape(DOMAIN)}/)}>#{SyntaxHighlighter::Language.escape(uri)}</a>")
        }

        return content
    end
end
