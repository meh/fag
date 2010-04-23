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

        @regexes.each {|regex, replace|
            if regex.is_a?(Array)
                regex.each {|re|
                    result.gsub!(re, replace)
                }
            else
                result.gsub!(regex, replace) rescue nil
            end
        }

        return result
    end
end

end

class Array
    def to_keywords
        keywords = String.new

        self.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^)(#{keywords[1, keywords.length]})(\s|$)/
    end
end
