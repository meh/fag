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

module ApplicationHelper
    def title
        result = 'fag'

        if @title
            result << " - #{@title}"
        end

        return result
    end

    def get_styles
        Dir.glob("#{Rails.public_path}/stylesheets/*.css").collect {|path|
            [File.basename(path, '.css'), File.basename(path)]
        }
    end

    def user (*args)
        ApplicationHelper.user(*args)
    end

    def escape (*args)
        ApplicationHelper.escape(*args)
    end

    def self.user (something)
        if something.is_a?(String)
            return something
        else
            return (something.user || something.name) rescue nil
        end
    end

    def self.escape (string)
        string.gsub(/(.)/) {|match|
            "%#{match.ord.to_s(16)}"
        }
    end
end
