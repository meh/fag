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

class Ruby < Language
    def initialize (content, options={})
        @operators = '[-\[\]\(\)\{\}~^@\/%|=+*!?\.\-,;]|&amp;|&lt;|&gt;'

        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m, /%([Qrq])?{({[^}]*}|.*?)*}/m] => lambda {|match| %{<span class="ruby string">#{Language.escape(match)}</span>}},

=begin
            [%r{([^<])(/(\\/|[^/])*/([imsx])?)}m, /(.)?(%r{({[^}]*}|.*?)*})/m] =>  lambda {|match|
                match = match.match(/^(.)(.*)$/)

                if match[1] != '/'
                    first  = match[1]
                    second = match[2]
                else
                    first  = ''
                    second = "/#{match[2]}"
                end

                "#{first}<span class=\"ruby regexp\">#{Language.escape(second)}</span>"
            },
=end

            /^(#.*?)$/ => '<span class="ruby comment">\1</span>',
            /(\s|\G|#{@operators})(:(("([^\\"]|\\.)*")|\w+))(#{@operators}|\s|\A)/ => '\1<span class="ruby string">\2</span>\6',

            /(do|{\s*)\|(.+?)\|/ => '\1|<span class="ruby parameters">\2</span>|',

            /(\s|\G|#{@operators})((@)?@\w+)(#{@operators}|\s|$)/ => '\1<span class="ruby variable">\2</span>\4',

            Ruby.keywords([
                'class', 'super', 'module', 'def', 'end', 'return', 'alias', 'nil',
                'begin', 'BEGIN', 'end', 'END', 'rescue', 'retry', 'ensure',
                'if', 'elsif', 'else', 'case', 'when', 'and', 'or', 'not',
                'do', 'while', 'for', 'in', 'unless', 'until', 'break', 'next', 'redo',
                'yield', 'undef', 'defined?'
            ]) => '\1<span class="ruby keyword">\2</span>\3',

            Ruby.functions([
                'require', 'load',
                'attr_reader', 'attr_writer', 'attr_accessor',
                'puts'
            ]) => '\1<span class="ruby function">\2</span>\3',
            
            /(\s|\G|#{@operators}|:)([A-Z]\w*)(#{@operators}|:|\s|$)/ => '\1<span class="ruby type">\2</span>\3',

            Ruby.constants([
                'self', 'nil', 'NIL', 'true', 'TRUE', 'false', 'FALSE',
                'STDIN', 'STDOUT', 'STDERR',
                'ENV', 'ARGF', 'ARGV', 'DATA',
                'RUBY_VERSION', 'RUBY_RELEASE_DATE', 'RUBY_PLATFORM',
                '__FILE__', '__LINE__', '__ENCODING__', '__END__',
            ]) => '\1<span class="ruby constant">\2</span>\3',
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

    def self.classes (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{result[1, result.length]})(\s|\.|:|$)/
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
