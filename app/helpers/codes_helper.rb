module CodesHelper
    def self.output (what, *args)
        CodesHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_owner (code)
        "<span class='owner'>#{
            UsersHelper.output :user, code.user || code.name
        }</span>"
    end
end
