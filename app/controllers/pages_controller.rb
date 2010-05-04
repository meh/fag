class PagesController < ApplicationController
    def about
        @title = 'about'
    end

    def rules
        @title = 'rules'
    end
end
