Cms::Application.routes.draw do

  resources :pages

  namespace :admin do 

  end

  namespace :site, :path => "site" do 
#    resources :login 
#    resources :articles
#    scope :controller => :articles do
#      match 'articles/:action/:id' => ':action#:id'
#      match 'articles/:action' => ':action'
#    end

    # User Sessions
    match 'user_sessions/:action' => 'user_sessions#:action'
    # Articles
    match 'articles/:action/:id' => 'articles#:action#:id'
    match 'articles/:action' => 'articles#:action'
    # Pages
    match 'pages/:action/:id' => 'pages#:action#:id'
    match 'pages/:action' => 'pages#:action'
    # Users
    match 'users/update/:id' => 'users#update#:id'
    match 'users/:action' => 'users#:action'
    # Theme
    match 'theme/:action' => 'theme#:action'
    # Layout
    match 'layout/:action' => 'layout#:action'
    # Setting
    match 'setting/:action' => 'setting#:action'
    # Optimization
    match 'optimization/:action' => 'optimization#:action'
    # Post setting
    match 'post_setting/:action' => 'post_setting#:action'
    # View setting
    match 'view_setting/:action' => 'view_setting#:action'
    
    
    # Images
    match 'images/:action/:id' => 'images#:action#:id'
    match 'images/:action' => 'images#:action'
    
    resource :user_session
    resources :users
  end

  resources :articles
  
#  root :to => 'home#show'
  

#  match 'pages/:site/:page' => 'pages#show#:site#:page'
  match ':site/pages/:page' => 'pages#show#:site#:page'
  match ':site/' => 'pages#show#:site'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
