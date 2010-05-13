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

class Falcon < Language
    def initialize (content, options={})
        @operators = '[-\[\]\(\)\{\}~^@\/%|=+*!?\.\-,;]|&amp;|&lt;|&gt;'

        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.)*')/m] => lambda {|match| %{<span class="falcon string">#{Language.escape(match)}</span>}},

            Falcon.keywords([
                'break', 'continue', 'dropping', 'return', 'launch', 'from', 'global', 'const',
                'self', 'sender', 'catch', 'raise', 'give', 'case', 'default', 'pass', 'lambda',
                'def', 'directive', 'load', 'export', 'loop', 'while', 'for', 'function', 'innerfunc',
                'init', 'static', 'attributes', 'forfirst', 'forlast', 'formiddle', 'enum', 'try',
                'class', 'switch', 'select', 'object', 'if', 'elif', 'else', 'end',
                'and', 'or', 'not', 'in', 'notin', 'to', 'as', 'has', 'hasnt', 'provides', 'eq',
                'all', 'any', 'allp', 'anyp', 'choice', 'xmap', 'cascade', 'dolist', 'iff', 'lit',
            ]) => '\1<span class="falcon keyword">\2</span>\3',

            Falcon.types([
                'Error', 'TraceStep', 'SyntaxError', 'CodeError', 'RangeError', 'MathError',
                'IoError', 'TypeError', 'ParamError', 'ParseError', 'CloneError', 'InterruptedError',
                'List',
            ]) => '\1<span class="falcon type">\2</span>\3',

            Falcon.functions([
                'eval',
            ]) => '\1<span class="falcon function">\2</span>\3',

            Falcon.constants([
                'nil', 'true', 'false',
            ]) => '\1<span class="falcon constant">\2</span>\3',
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
