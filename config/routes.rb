ActionController::Routing::Routes.draw do |map|
    map.root :controller => 'news'

    map.ocean      'ocean',              :controller => 'flows'
    map.oceanNew   'ocean/new/flow',     :controller => 'flows', :action => 'new', :type => 'flow'
    map.connect    'flows/new/drop.:id', :controller => 'flows', :action => 'new', :type => 'drop'
    map.flow       'ocean/flow/:id',     :controller => 'flows', :action => 'show'
    map.projects   'projects',           :controller => 'flows', :action => 'projects'
    map.subscribed 'subscribed',         :controller => 'flows', :action => 'subscribed'
    map.rawCodes   'codes/:id.raw',      :controller => 'codes', :action => 'raw'

    map.register  'register', :controller => 'users',    :action => 'new'
    map.login     'login',    :controller => 'sessions', :action => 'new'
    map.logout    'logout',   :controller => 'sessions', :action => 'destroy'

    map.about 'about', :controller => 'pages', :action => 'about'

    map.resources :users
    map.resources :sessions, :only => [:new, :create, :destroy]
    map.resources :flows
    map.resources :tags
    map.resources :codes

    map.connect ':controller/:action/:id'
end
