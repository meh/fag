module TagsHelper
    def self.output (what, *args)
        TagsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_link (tag)
        if tag.is_a?(UsedTag)
            tag = tag.tag
        end

        "<a href='/tags/#{ApplicationHelper.escape tag.name}'>#{ERB::Util.h tag.name}</a>"
    end
end
