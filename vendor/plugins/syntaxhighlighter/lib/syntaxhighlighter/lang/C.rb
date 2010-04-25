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

class C < Language
    def initialize (content, options={})
        @regexes = {
            /^\s*(#.*)$/ => lambda {|match| "<span class='c preprocessor'>#{Language.escape(match)}</span>"},

            /("([^\\"]|\\.)*")/m => lambda {|match| "<span class='c string'>#{Language.escape(match)}</span>"},
            /('(\\.|[^\\'])')/ => lambda {|match| "<span class='c char'>#{Language.escape(match)}</span>"},

            /(\/\*.*?\*\/)/m => lambda {|match| "<span class='c comment'>#{Language.escape(match)}</span>"},
            /(\/\/.*)$/ => lambda {|match| "<span class='c comment'>#{Language.escape(match)}</span>"},

            C.keywords([:if, :while, :for, :return, :extern, :const, :static]) => '\1<span class="c keyword">\2</span>\3',
            C.types([:void, :int, :char]) => '\1<span class="c type">\2</span>\3'
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^|\(|\))(#{keywords[1, keywords.length]})(\{|\(|\)|\*|\s|$)/
    end

    def self.types (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^|\(|\))(#{result[1, result.length]})(\{|\(|\)|\*|\s|$)/
    end
end

end

end
