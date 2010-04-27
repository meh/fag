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

class Bash < Language
    def initialize (content, options={})
        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m] => lambda {|match| "<span class=\"bash string\">#{Language.escape(match)}</span>"},
            /^(#.*?)$/ => '<span class="bash comment">\1</span>',

            Bash.keywords(['if', 'fi', 'while', 'do', 'case', 'esac', 'for', 'function']) => '\1<span class="bash keyword">\2</span>\3',
            Bash.functions(['echo', 'cat', 'grep', 'sed', 'curl']) => '\1<span class="bash function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{keywords[1, keywords.length]})(\(|\)|\*|\s|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{result[1, result.length]})(\s|\(|$)/
    end
end

end

end
