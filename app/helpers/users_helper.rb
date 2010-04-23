module UsersHelper
    def self.output (what, *args)
        UsersHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_class (user)
        if user.is_a?(User)
            return ERB::Util.h user.modes[:class].to_s
        else
            return 'anonymous'
        end
    end

    def self.output_user (user)
        if user.is_a?(User)
            return "<a href='/users/#{ERB::Util.h user.id}'>#{ERB::Util.h user.name}</a>"
        else
            return user || 'Anonymous'
        end
    end
end
