# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def title
        result = 'fag'

        if @title
            result << " - #{@title}"
        end

        return result
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
