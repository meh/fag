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

            [Hybris.keywords([
                :include, :import,
                :typeof, :sizeof,
                :true, :false, :null,
                :if, :else, :while, :do, :for, :foreach, :of, :break, :next, :switch, :case, :default,
                :throw, :try, :catch, :finally,
                :function, :return, :class, :public, :protected, :private, :method, :operator, :new, :extends, :me,

            ]), /(\s|\G|\(|\)|[-~^@\/%|=+*!?\.\-]|&amp;|&lt;|&gt;)(me)(\(|\)|\[\]|[-~^@\/%|=+*!?\.\-]|&amp;|&lt;|&gt;|\(|\)|$)/] => '\1<span class="hybris keyword">\2</span>\3',

            Hybris.functions([
                :isint, :isfloat, :ischar, :isarray, :ismap, :isalias, :toint, :tostring, :fromxml, :toxml,
                :var_names, :var_values, :user_funcions, :dyn_functions, :call,

                :print, :println, :printf, 
                :sqrt, :sin, :sinh, :cos, :cosh, :pow, :tan, :tanh, :log, :log10, :fmod, :floor, :ceil, :fabs, :exp, :atan, :atan2, :acos, # math
                :crc32, :sha1, :sha2, :md5,
                :rex_match, :rex_matches, :rex_replace,
                :smtp_send,
                :http, :http_get, :http_post,
                :urlencode, :urldecode, :base64encode, :base64decode,
                :input,
                :xml_load, :xml_parse,
                :fopen, :fseek, :ftell, :fsize, :fread, :fwrte, :fgets, :fclose, :file, :readdir,
                :strlen, :strfind, :substr, :strreplace, :strsplit,
                :settimeout, :server, :accept, :recv, :send, :close,
                :exit, :popen, :pclose, :wait, :getpid, :fork, :exec,
                :dlopen, :dlllink, :dllcall, :dllclose,
                :pthread_create, :pthread_exit, :pthread_join,
                :ticks, :usleep, :sleep,
                :time, :strtime, :strdate,

                :binary, :pack,
                :array, :contains, :elements, :pop, :remove,
                :map, :mapelements, :mappop, :unmap, :ismappd, :haskey,
                :matrix, :columns, :rows,
            ]) => '\1<span class="hybris function">\2</span>\3',
        }

        super(content, options)
    end

    def self.keywords (value)
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

        return /(\s|\G|\(|\))(#{result[1, result.length]})(\s|\(|$)/
    end
end

end

end
