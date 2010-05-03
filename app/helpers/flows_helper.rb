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

module FlowsHelper
    def self.output (what, *args)
        FlowsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_link (flow)
        "<a href='/ocean/flow/#{flow.id}'>#{FlowsHelper.output :title, flow}</a>"
    end

    def self.output_last_post (flow, template='#{at} #{by}')
        drop = flow.drops.last


        at = nil
        by = nil

        if drop
            at = drop.created_at
            by = UsersHelper.output(:user, ApplicationHelper.user(drop))
        end

        return templatify(template, binding)
    end

    def self.output_title (flow)
        return ERB::Util.h flow.title
    end

    def self.output_tags (flow, wholeFormat=nil, tagFormat=nil)
        wholeFormat ||= '#{tags}'
        tagFormat   ||= '&quot;<a href="#{url}" class="float #{type}">#{name}</a>&quot;'

        tags = String.new

        flow.used_tags.each {|tag|
            tags << "#{TagsHelper.output :link, tag, tagFormat} "
        }

        return templatify(wholeFormat, binding)
    end

    def self.output_content (drop)
        content = (drop.is_a?(Drop) ? drop.content : drop.to_s).clone
        
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
            content.gsub!(/#{Regexp.escape(match[1])}/, ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => 'codes/show', :locals => { :code => Code.find(match[4]), :inDrop => true }).strip)
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
