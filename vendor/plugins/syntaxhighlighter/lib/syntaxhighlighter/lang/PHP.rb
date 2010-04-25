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

class PHP < Language
    def initialize (content, options={})
        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m] => lambda {|match| "<span class=\"php string\">#{Language.escape(match)}</span>"},

            /^(#.*?)$/ => '<span class="php comment">\1</span>',
            /(\/\*.*?\*\/)/m => lambda {|match| "<span class='php comment'>#{Language.escape(match)}</span>"},
            /(\/\/.*)$/ => lambda {|match| "<span class='php comment'>#{Language.escape(match)}</span>"},

            /(\s|^)(\$)(\w+)/ => '\1<span class="php variable"><span class="php variable symbol">$</span>\3</span>',

            PHP.keywords([:function, :if, :while, :for, :return]) => '\1<span class="php keyword">\2</span>\3',
            PHP.functions([:require, :require_once, :include, :include_once, :echo]) => '\1<span class="php function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G)(#{keywords[1, keywords.length]})(\s|$)/
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
