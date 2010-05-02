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

class SQL < Language
    def initialize (content, options={})
        @regexes = {
            [/("([^\\"]|\\.)*")/m, /('([^\\']|\\.|'')*')/m] => lambda {|match| "<span class=\"sql string\">#{Language.escape(match)}</span>"},

            [/^(--.*?)$/, /({({[^}]*}|.*?)*})/m] => '<span class="sql comment">\1</span>',

            SQL.keywords([
                'CREATE', 'UNIQUE', 'TABLE', 'DATABASE', 'INDEX', 'SEQUENCE', 'PRIMARY', 'KEY',
                'COMMENT', 'SCHEMA', 'INCREMENT', 'OWNED', 'OWNER', 'CACHE', 'COPY',
                'SELECT', 'DISTINCT', 'UNION', 'FROM', 'AS', 'TO', 'IS', 'ON', 'IN', 'WITH', 'NO', 'ANY',
                'JOIN', 'INNER', 'LEFT', 'RIGHT',
                'WHERE', 'ALL', 'BETWEEN', 'HAVING', 'ONLY',
                'TOP', 'ORDER', 'DESC', 'ASC',
                'GROUP', 'BY',
                'INSERT', 'INTO', 'VALUES',
                'ALTER', 'ADD', 'CONSTRAINT', 'SET',
                'AND', 'OR', 'NOT', 'NULL', 'DEFAULT',
            ]) => '\1<span class="sql keyword">\2</span>\3',

            SQL.functions([
                'COUNT', 'MAX', 'MIN', 'AVG', 'SUBSTR', 'LEN', 'SUM',
            ]) => '\1<span class="sql function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
        keywords = String.new

        value.each {|key|
            keywords << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G|\()(#{keywords[1, keywords.length]})([,;]|\s|$)/i
    end

    def self.functions (value)
        result = String.new

        value.each {|key|
            result << "|#{Regexp.escape(key.to_s)}"
        }

        return /(\s|\G)(#{result[1, result.length]})([,;]|\(|\s|$)/i
    end
end

end

end