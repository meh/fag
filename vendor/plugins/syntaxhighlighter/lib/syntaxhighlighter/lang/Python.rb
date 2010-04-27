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

class Python < Language
    def initialize (content, options={})
        @regexes = {
            [/('([^\\']|\\.)*')/m, /(""".*?""")/m, /("([^\\"]|\\.)*")/m] => lambda {|match| "<span class='python string'>#{Language.escape(match)}</span>"},

            /^(#.*?)$/ => '<span class="python comment">\1</span>',

            Python.keywords([
                'global', 'exec', 'del', 'with',
                'from', 'import', 'as',
                'if', 'elsif', 'else', 'while', 'for', 'in', 'not', 'and', 'or', 'break', 'pass', 'continue',
                'raise', 'try', 'except', 'finally',
                'is', 'def', 'lambda', 'return', 'class', :self
            ]) => '\1<span class="python keyword">\2</span>\3',

            Python.functions([
                'abs', 'all', 'any',
                'basestring', 'bin', 'bool',
                'callable', 'chr', 'classmethod', 'cmp', 'compile', 'complex',
                'delattr', 'dict', 'dir', 'divmod',
                'enumerate', 'eval', 'execfile',
                'file', 'filter', 'float', 'format', 'frozenset',
                'getattr', 'globals',
                'hasattr', 'hash', 'help', 'hex',
                'id', 'input', 'int', 'isinstance', 'issubclass', 'iter', 
                'len', 'list', 'locals', 'long',
                'map', 'max', 'min',
                'next',
                'object', 'oct', 'open', 'ord',
                'pow', 'print', 'property',
                'range', 'raw_input', 'redue', 'reload', 'repr', 'reversed', 'round',
                'set', 'setattr', 'slice', 'sorted', 'staticmethod', 'str', 'sum', 'super',
                'tuple', 'type',
                'unichr', 'unicode',
                'vars',
                'xrange',
                'zip',
                '__import__',
            ]) => '\1<span class="python function">\2</span>\3',

            Python.constants(['True', 'False', 'None', 'NotImplemented', 'Ellipsis']) => '\1<span class="python constant">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\))(#{result[1, result.length]})(:|\(|\)|\*|\s|$)/
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\)|,)(#{result[1, result.length]})(\s|\(|$)/
    end

    def self.constants (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\(|\)|[-~^@\/%|=+*!?\.\-]|&amp;|&lt;|&gt;)(#{result[1, result.length]})(\(|\)|\[\]|[-~^@\/%|=+*!?\.\-]|&amp;|&lt;|&gt;|\(|\)|$)/
    end
end

end

end
