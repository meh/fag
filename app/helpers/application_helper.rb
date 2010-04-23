# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def title
        result = 'fag'

        if @title
            result << " - #{@title}"
        end

        return result
    end

    def user (something)
        if something.is_a?(String)
            return something
        else
            return (something.user || something.name) rescue nil
        end
    end
end
