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
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m] => '<span class="string">\1</span>',
            /^(#.*)$/ => '<span class="comment">\1</span>',
            /\|(.+?)\|/ => '|<span class="ruby parameters">\1</span>|',
            [:class, :module, :def, :end, :if, :do, :while, :for, :unless, :return, :begin, :rescue, :fail].to_keywords => '\1<span class="keyword">\2</span>\3',
            Ruby.classes([:Array, :Hash, :File]) => '\1<span class="class">\2</span>\3',
            Ruby.functions([:puts]) => '\1<span class="function">\2</span>\3',
        }

        super(content, options)
    end

    def self.classes (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^)(#{result[1, result.length]})(\s|\.|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^)(#{result[1, result.length]})(\s|\(|$)/

    end
end

end

end
