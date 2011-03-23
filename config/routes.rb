Cms::Application.routes.draw do

#  resources :pages

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
    # Blogs
    match 'blogs/:action/:id' => 'blogs#:action#:id'
    match 'blogs/:action' => 'blogs#:action'
    # Users
    match 'users/:action/:id' => 'users#action#:id'
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
    # Widgets setting
    match 'widgets/:action/:id' => 'widgets#:action#:id'
    match 'widgets/:action' => 'widgets#:action'

    match 'text_widget/:action/:id' => 'text_widget#:action#:id'
    match 'company_profile_widget/:action/:id' => 'company_profile_widget#:action#:id'

    # Inquiry Item setting
    match 'inquiry_items/:action/:id' => 'inquiry_items#:action#:id'
    match 'inquiry_items/:action' => 'inquiry_items#:action'
    
    match 'text_inquiry_item/:action/:id' => 'text_inquiry_item#:action#:id'
    match 'radio_inquiry_item/:action/:id' => 'radio_inquiry_item#:action#:id'
    match 'checkbox_inquiry_item/:action/:id' => 'checkbox_inquiry_item#:action#:id'
    match 'email_inquiry_item/:action/:id' => 'email_inquiry_item#:action#:id'


    # Images
    match 'images/:action/:id' => 'images#:action#:id'
    match 'images/:action' => 'images#:action'
    
    # Informations
    match 'informations/:action/:id' => 'informations#:action#:id'
    
    # dashboard
    match 'dashboard/:action' => 'dashboard#:action'
    
    match '/' => 'dashboard#index'
    
    resource :user_session
    resources :users
  end

#  resources :articles
  
#  root :to => 'home#show'
  
  match 'sitemap.:format' => 'sitemap#index#:format'
  

#  match 'pages/:site/:page' => 'pages#show#:site#:page'
  match ':site/pages/:page' => 'pages#show#:site#:page'

  match ':site/blogs/:id' => 'blogs#show#:site#:id'
  match ':site/blogs/month/:month' => 'blogs#month#:site#:month'

  match ':site/articles/index.:format' => 'articles#index#:format#:site'
  match ':site/articles/index' => 'articles#index'

#  match ':site/articles/index.:format' => 'articles#index.:format#:site'


  match ':site/inquiry/:action' => 'inquiry#:action#:site'


  # 公開 - サイトの root
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
