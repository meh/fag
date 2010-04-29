ActionController::Routing::Routes.draw do |map|
    map.root :controller => 'flows', :action => 'search'

    map.connect 'ocean',                :controller => 'flows'
    map.connect 'ocean/new/flow',       :controller => 'flows', :action => 'new'
    map.connect 'ocean/new/flow/:tag',  :controller => 'flows', :action => 'new'
    map.connect 'ocean/flow/:id',       :controller => 'flows', :action => 'show'
    map.connect 'ocean/search',         :controller => 'flows', :action => 'search'
    map.connect 'ocean/search/:tag',    :controller => 'flows', :action => 'search'
    map.connect 'projects',             :controller => 'flows', :action => 'projects'
    map.connect 'subscribed',           :controller => 'flows', :action => 'subscribed'
    map.connect 'codes/:id.raw',        :controller => 'codes', :action => 'raw'
    map.connect 'flows/drop/:what/:id', :controller => 'flows', :action => 'drop'

    map.connect 'register', :controller => 'users',    :action => 'new'
    map.connect 'login',    :controller => 'sessions', :action => 'new'
    map.connect 'logout',   :controller => 'sessions', :action => 'destroy'

    map.connect 'about', :controller => 'pages', :action => 'about'

    map.resources :users
    map.resources :sessions, :only => [:new, :create, :destroy]
    map.resources :flows
    map.resources :tags
    map.resources :codes

    map.connect ':controller/:action/:id'
end
