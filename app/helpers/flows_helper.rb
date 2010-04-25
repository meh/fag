module FlowsHelper
    def self.output (what, *args)
        FlowsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_link (flow)
        "<a href='/ocean/flow/#{flow.id}'>#{FlowsHelper.output :title, flow}</a>"
    end

    def self.output_last_post (flow, template='%s %s')
        drop = flow.drops.last

        template % [drop.created_at, UsersHelper.output(:user, ApplicationHelper.user(drop))]
    end

    def self.output_title (flow)
        return ERB::Util.h flow.title
    end

    def self.output_tags (flow)
        result = String.new

        flow.used_tags.each {|tag|
            result << "#{TagsHelper.output :link, tag} "
        }

        return result
    end

    def self.output_content (drop)
        content = drop.content.gsub(/</, '&lt;').gsub(/>/, '&gt;')

        content.scan(/("([^"]+)":(\w+:\/\/[^\s]+))/).uniq.each {|match|
            if match[1].strip.empty?
                next
            end

            content.gsub!(/#{Regexp.escape(match[0])}/, "<a href='#{SyntaxHighlighter::Language.escape(match[2])}'>#{ERB::Util.h match[1]}</a>")
        }

        content.gsub!('"', '&quot;')

        content.scan(/^(\s*&lt; \/code(s)?\/(\d+)\n)$/).uniq.each {|match|
            content.gsub!(/#{Regexp.escape(match[0])}/, ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => 'codes/show', :locals => { :code => Code.find(match[2]), :inDrop => true }).strip)
        }

        return content
    end
end
