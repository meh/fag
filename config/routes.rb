ActionController::Routing::Routes.draw do |map|
    map.root :controller => 'flows', :action => 'home'

    map.connect 'stylesheets/theme.css', :controller => 'themes', :action => 'css'

    map.connect 'ocean',                        :controller => 'flows'
    map.connect 'ocean/new/flow',               :controller => 'flows', :action => 'new'
    map.connect 'ocean/new/flow/:tag',          :controller => 'flows', :action => 'new'
    map.connect 'ocean/flow/:id',               :controller => 'flows', :action => 'show'
    map.connect 'ocean/search',                 :controller => 'flows', :action => 'search'
    map.connect 'ocean/search.rss',             :controller => 'flows', :action => 'search', :rss => true
    map.connect 'ocean/search/:expression',     :controller => 'flows', :action => 'search'
    map.connect 'ocean/search.rss/:expression', :controller => 'flows', :action => 'search', :rss => true
    map.connect 'flows/drop/:what/:id',         :controller => 'flows', :action => 'drop'
    map.connect 'flows/following',              :controller => 'flows', :action => 'subscriptions'
    map.connect 'flows/following/:user',        :controller => 'flows', :action => 'subscriptions'
    map.connect 'flows/following/:user.rss',    :controller => 'flows', :action => 'subscriptions', :rss => true
    map.connect 'flows/follow/:id',             :controller => 'flows', :action => 'subscribe'
    map.connect 'flows/unfollow/:id',           :controller => 'flows', :action => 'unsubscribe'
    map.connect 'flows/search!',                :controller => 'flows', :action => 'do_search'

    map.connect 'codes/:id.raw', :controller => 'codes', :action => 'raw'

    map.connect 'project/:name', :controller => 'projects', :action => 'show'

    map.connect 'register', :controller => 'users',    :action => 'new'
    map.connect 'login',    :controller => 'sessions', :action => 'new'
    map.connect 'logout',   :controller => 'sessions', :action => 'destroy'

    map.connect 'about', :controller => 'pages', :action => 'about'
    map.connect 'intro', :controller => 'pages', :action => 'intro'
    map.connect 'rules', :controller => 'pages', :action => 'rules'

    map.resources :users
    map.resources :sessions, :only => [:new, :create, :destroy]
    map.resources :bans
    map.resources :flows
    map.resources :tags
    map.resources :codes
    map.resources :projects

    map.connect ':controller/:action/:id'
end
