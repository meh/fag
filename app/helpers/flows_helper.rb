module FlowsHelper
    def self.output (what, *args)
        FlowsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_title (flow)
        return ERB::Util.h flow.title
    end

    def self.output_content (drop)
        content = ERB::Util.h drop.content

        content.scan(/^(\s*&lt; \/code(s)?\/(\d+))$/).uniq.each {|match|
            content.gsub!(/#{Regexp.escape(match[0])}/, ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => 'codes/show', :locals => { :code => Code.find(match[2]), :inDrop => true }))
        }

        content.scan(/("([^"])":([^\s]))/).uniq.each {|match|

        }

        return content
    end
end
