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

require 'syntaxhighlighter/language'

class SyntaxHighlighter

class Language

class Go < Language
    def initialize (content, options={})
        @operators = '[-\[\]\(\)\{\}~^@\/%|=+*!?\.\-,;]|&amp;|&lt;|&gt;'

        @regexes = {
            /("([^\\"]|\\.)*")/m => lambda {|match| %{<span class="go string">#{Language.escape(match)}</span>}},

            Go.keywords([
                'break', 'case', 'chan', 'const', 'continue', 'default', 'defer',
                'else', 'fallthrough', 'for', 'func', 'go', 'goto', 'if', 'import',
                'interface', 'map', 'package', 'range', 'return', 'select', 'struct',
                'switch', 'type', 'var',
            ]) => '\1<span class="go keyword">\2</span>\3',

            Go.types([
                'bool', 'uint', 'int', 'float', 'complex', 'uintptr',
                'uint8', 'uint16', 'uint32', 'uint64', 'int8', 'int16', 'int32', 'int64',
                'float32', 'float64', 'complex64', 'complex128', 'byte',
            ]) => '\1<span class="go type">\2</span>\3',

            Go.functions([
                'fmt', 'Printf',
            ]) => '\1<span class="go function">\2</span>\3',

            Go.constants([
                'nil', 'true', 'false',
            ]) => '\1<span class="go constant">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G)(#{keywords[1, keywords.length]})(\(|\s|$)/
    end

    def self.types (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{result[1, result.length]})(\{|\(|\)|\*|\s|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|#{@operators})(#{result[1, result.length]})(#{@operators}|\s|$)/
    end

    def self.constants (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|#{@operators})(#{result[1, result.length]})(#{@operators}|\s|$)/
    end
end

end

end
