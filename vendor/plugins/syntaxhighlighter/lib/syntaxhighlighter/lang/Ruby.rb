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
        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m] => lambda {|match| "<span class=\"ruby string\">#{Language.escape(match)}</span>"},
            /^(#.*?)$/ => '<span class="ruby comment">\1</span>',

            /(do|{\s*)\|(.+?)\|/ => '\1|<span class="ruby parameters">\2</span>|',

            Ruby.keywords([:class, :module, :def, :end, :if, :do, :while, :for, :unless, :return, :begin, :rescue, :fail]) => '\1<span class="ruby keyword">\2</span>\3',
            Ruby.classes([:Array, :Hash, :Regexp, :File, :URI, 'Net::HTTP']) => '\1<span class="ruby type">\2</span>\3',
            Ruby.functions([:require, :load, :puts]) => '\1<span class="ruby function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^)(#{keywords[1, keywords.length]})(\s|$)/
    end

    def self.classes (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^|\(|\))(#{result[1, result.length]})(\s|\.|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^|\(|\))(#{result[1, result.length]})(\s|\(|$)/
    end
end

end

end