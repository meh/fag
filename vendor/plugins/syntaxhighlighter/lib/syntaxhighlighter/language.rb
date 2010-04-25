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

class SyntaxHighlighter

class Language
    attr_reader :content, :options

    def initialize (content, options={})
        @content = content
        @options = options

        @regexes ||= {}
    end

    def highlight
        result = self.content.clone

        result.gsub!(/&/, '&amp;')
        result.gsub!(/</, '&lt;')
        result.gsub!(/>/, '&gt;')

        @regexes.each {|regex, replace|
            if regex.is_a?(Array)
                regex.each {|re|
                    if replace.class == Proc
                        result.gsub!(re, &replace)
                    else
                        result.gsub!(re, replace)
                    end
                }
            else
                if replace.class == Proc
                    result.gsub!(regex, &replace)
                else
                    result.gsub!(regex, replace)
                end
            end
        }

        return result
    end

    def self.escape (value)
        value.gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&').gsub(/(.)/) {|match|
            "&##{match[0].ord};"
        }
    end
end

end