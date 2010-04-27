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
        'Plain' => [/^t(e)?xt$/i, /^plain$/i],

        'Bash' => /^(ba)?sh$/i,

        'Ruby'       => [/^ruby$/i, /^rb$/i],
        'Javascript' => [/^javascript$/i, /^js$/i],
        'PHP'        => /^php$/i,  
        'Hybris'     => [/^hybris$/i, /^hy$/i],
        'Python'     => [/^python$/i, /^py$/i],

        'C'        => /^c$/i,
        'C++'      => { :regexes => /^c(\+\+|pp)$/i, :class => 'Cpp' },
        'ASM AT&T' => { :regexes => /^gas$/i, :class => 'Gas' },
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
            puts "LOLOL #{highlighter.inspect}"
        end

        if highlighter
            highlighter.new(code).highlight
        else
            return code
        end
    end

    def self.include (value)
        name = SyntaxHighlighter.language(value)

        if @@languages[name].is_a?(Hash)
            name = @@languages[name][:class].to_s
        end

        if !name
            return
        end

        begin
            require "syntaxhighlighter/lang/#{name}"
        rescue Exception => e
            $stderr.puts e.inspect
            return Exception
        end
    end

    def self.class! (value)
        name = SyntaxHighlighter.language(value)

        if @@languages[name].is_a?(Hash)
            name = @@languages[name][:class].to_s
        end

        if !name
            return
        end

        begin
            eval("SyntaxHighlighter::Language::#{name}")
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

        @@languages.each {|language, data|
            if data.is_a?(Array)
                data.each {|regex|
                    return language if value.match(regex)
                }
            else
                if data.class == Regexp
                    return language if value.match(data)
                elsif data.is_a?(Hash)
                    regexes = data[:regexes]
                    
                    if regexes.class == Regexp
                        return language if value.match(regexes)
                    elsif regexes.is_a?(Array)
                        regexes.each {|regex|
                            return language if value.match(regex)
                        }
                    end
                end
            end
        }

        if name
            return value
        else
            return nil
        end
    end
end
