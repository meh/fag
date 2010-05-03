module ProjectsHelper
    def self.output (what, *args)
        ProjectsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_link (project)
        "<a class='project' href='/projects/#{ApplicationHelper.escape project.name}'>#{SyntaxHighlighter::Language.escape(project.name)}</a>"
    end
end
