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
    attr_reader :language

    @@languages = {
        'Ruby' => [/^ruby$/i, /^rb$/i],
        'C'    => [/^c$/i],
    }

    def initialize (lang)
        @language = SyntaxHighlighter.language(lang)
    end

    def highlight (code)
        return SyntaxHighlighter.highlight(@language, code)
    end

    def self.highlight (lang, code)
        lang = SyntaxHighlighter.language(lang)

        SyntaxHighlighter.include(lang)
        
        if !(highlighter = SyntaxHighlighter.class!(lang))
            SyntaxHighlighter.include('Plain')
            highlighter = SyntaxHighlighter.class!('Plain')
        end

        if highlighter
            highlighter.new(code).highlight
        else
            return code
        end
    end

    def self.include (value)
        begin
            require "syntaxhighlighter/lang/#{SyntaxHighlighter.language(value)}"
        rescue Exception => e
            $stderr.puts e.inspect
            return Exception
        end
    end

    def self.class! (value)
        begin
            eval("SyntaxHighlighter::Language::#{SyntaxHighlighter.language(value)}")
        rescue Exception => e
            $stderr.puts e.inspect
            return nil
        end
    end

    def self.language (value, name=false)
        if !value.is_a?(String)
            return nil
        end

        if @@languages[value]
            return value
        end

        @@languages.each {|language, regexes|
            regexes.each {|regex|
                if value.match(regex)
                    return language
                end
            }
        }

        if name
            return value
        else
            return nil
        end
    end
end
