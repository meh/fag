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

class Hybris < Language
    def initialize (content, options={})
        @regexes = {
            /("([^\\"]|\\.)*")/m => lambda {|match| "<span class='hybris string'>#{Language.escape(match)}</span>"},
            /('(\\.|[^\\'])')/ => lambda {|match| "<span class='hybris char'>#{Language.escape(match)}</span>"},

            /(\/\*.*?\*\/)/m => lambda {|match| "<span class='hybris comment'>#{Language.escape(match)}</span>"},
            /(\/\/.*)$/ => lambda {|match| "<span class='hybris comment'>#{Language.escape(match)}</span>"},

            Hybris.keywords([:include, :import, :if, :else, :while, :for, :foreach, :of, :try, :catch, :finally, :throw, :function, :class, :public, :protected, :private, :method, :return]) => '\1<span class="hybris keyword">\2</span>\3',

            Hybris.functions([
                :println,
                :sqrt, # math
                :array, :contains, :elements, :pop, :remove, # array
                :map, # map
            ]) => '\1<span class="hybris function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^|\(|\))(#{result[1, result.length]})({|\(|\)|\*|\s|$)/
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
