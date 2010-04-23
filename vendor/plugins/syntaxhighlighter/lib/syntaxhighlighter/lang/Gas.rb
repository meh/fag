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

class Gas < Language
    def initialize (content, options={})
        @regexes = {
            /("([^\\"]|\\.)*")/m => lambda {|match| "<span class='string'>#{Language.escape(match)}</span>"},

            /(\/\*.*?\*\/)/m => lambda {|match| "<span class='comment'>#{Language.escape(match)}</span>"},

            /(\s|^)(\.[^\s]+)/ => '\1<span class="gas section">\2</span>',

            /(\w+)(\s*[:=][^'"])/ => '<span class=\'gas label\'>\1</span>\2',

            /(%\w+)/ => '<span class="gas register">\1</span>',
            /(\$\w+)/ => '<span class="gas constant">\1</span>',

            Gas.instructions([
                :mov, :movzb, :movzw, :movzl, :lea,
                :cmp, :cmove, :cmovne,
                :jmp, :int, :call, :ret, :loop,
                :push, :pop,
                :neg, :not, :and, :or, :sal, :sar, :shr, :shl,
                :sub, :dec, :add, :inc, :div,
                :jl, :je, :jne, :jb, :jg, :jge,
                :cld, :bswap,
                :repne, :scasb,
            ]) => '\1<span class="keyword">\2\3</span>\4',
        }

        super(content, options)
    end

    def self.instructions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|^)(#{result[1, result.length]})([bwlq])?(\s|$)/

    end
end

end

end
