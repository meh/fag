ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
    map.root :controller => 'news'

    map.resources :users
    map.resources :sessions, :only => [:new, :create, :destroy]
    map.resources :flows
    map.resources :codes

    map.ocean    'ocean',              :controller => 'flows'
    map.oceanNew 'ocean/new/flow',     :controller => 'flows', :action => 'new', :type => 'flow'
    map.connect  'flows/new/drop.:id', :controller => 'flows', :action => 'new', :type => 'drop'
    map.flow     'ocean/flow/:id',     :controller => 'flows', :action => 'show'
    map.projects 'projects',           :controller => 'flows', :action => 'projects'

    map.register  'register', :controller => 'users',    :action => 'new'
    map.login     'login',    :controller => 'sessions', :action => 'new'
    map.logout    'logout',   :controller => 'sessions', :action => 'destroy'

    map.about 'about', :controller => 'pages', :action => 'about'

    map.connect ':controller/:action/:id'
end
