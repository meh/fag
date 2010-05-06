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

module ApplicationHelper
    def title
        result = TITLE.clone

        if @title
            result << " - #{@title}"
        end

        return result
    end

    def get_styles (user=current_user)
        [Dir.glob("#{RAILS_ROOT}/themes/*").collect {|path|
            name = File.basename(path)

            [name, name]
        }, { :selected => (user ? user.theme : 'default') }]
    end

    def escape (*args)
        ApplicationHelper.escape(*args)
    end

    def filter_output (content)
        content = content.clone
        
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
            content.gsub!(/#{Regexp.escape(match[1])}/, ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => "#{theme_path}/codes/show.html.erb", :locals => { :code => (Code.find(match[5]) rescue nil), :inself => true }).strip)
        }

        URI.extract(content).uniq.each {|uri|
            if !uri.match(%r{^\w+://})
                next
            end

            content.gsub!(/#{Regexp.escape(uri)}/, "<a href='#{SyntaxHighlighter::Language.escape(uri)}' #{'target="_blank"' if !uri.match(/http:\/\/#{Regexp.escape(DOMAIN)}/)}>#{SyntaxHighlighter::Language.escape(uri)}</a>")
        }

        return content
    end

    def self.escape (string)
        string.gsub(/(.)/) {|match|
            "%#{match.ord.to_s(16)}"
        }
    end
end
