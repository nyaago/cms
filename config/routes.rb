Cms::Application.routes.draw do

#  resources :pages

  namespace :admin do 
  end

  # User Sessions
  match 'user_sessions' => 'user_sessions#action'
  match 'user_sessions/:action' => 'user_sessions#:action'

  namespace :admin, :path => "admin" do 
    match 'sites' => 'sites#index'
    match 'sites/:action/:id' => 'sites#:action#:id'
    match 'sites/:action' => 'sites#:action'

    match 'users' => 'users#index'
    match 'users/:action/:id' => 'users#:action#:id'
    match 'users/:action' => 'users#:action'

    match 'information' => 'information#index'
    match 'information/:action/:id' => 'information#:action#:id'
    match 'information/:action' => 'information#:action'

    match 'common/:action' => 'common#:action'

    # password
    match 'password' => 'password#index'
    match 'password/:action/:id' => 'password#:action#:id'
    match 'password/:action' => 'password#:action'
    
    # 
    match 'sites/:action/:format' => 'sites#index#:format'

    match '' => 'sites#index'
  end

  namespace :site_admin, :path => "site" do 
#    resources :login 
#    resources :articles
#    scope :controller => :articles do
#      match 'articles/:action/:id' => ':action#:id'
#      match 'articles/:action' => ':action'
#    end
    
    match ':site/common/:action' => 'common#:action#:site'
    match 'common/:action' => 'common#:action'

    # password reissue
    match 'password_reissue' => 'password_reissue#index'
    match 'password_reissue/:action/:id' => 'password_reissue#:action#:id'
    match 'password_reissue/:action' => 'password_reissue#:action'

    # Articles
    match ':site/articles/:action/:id' => 'articles#:action#:id#:site'
    match ':site/articles/:action' => 'articles#:action#:site'
    # Pages
    match ':site/pages' => 'pages#index#:site'
    match ':site/pages/:action/:id' => 'pages#:action#:id#:site'
    match ':site/pages/:action' => 'pages#:action#:site'
    
    # Blogs
    match ':site/blogs' => 'blogs#index#:site'
    match ':site/blogs/:action/:id' => 'blogs#:action#:id#:site'
    match ':site/blogs/:action' => 'blogs#:action#:site'
    
    # Users
    match ':site/users' => 'users#index#:site'
    match ':site/users/:action/:id' => 'users#action#:id#:site'
    match ':site/users/:action' => 'users#:action#:site'
    
    # Theme
    match ':site/theme' => 'theme#index#:site'
    match ':site/theme/:action' => 'theme#:action#:site'
    
    # Layout
    match ':site/layout' => 'layout#index#:site'
    match ':site/layout/:action' => 'layout#:action#:site'
    
    # Setting
    match ':site/setting' => 'setting#index#:site'
    match ':site/setting/:action' => 'setting#:action#:site'
    # Optimization
    match ':site/optimization' => 'optimization#index#:site'
    match ':site/optimization/:action' => 'optimization#:action#:site'
    # Post setting
    match ':site/post_setting' => 'post_setting#index#:site'
    match ':site/post_setting/:action' => 'post_setting#:action#:site'
    # View setting
    match ':site/view_setting' => 'view_setting#index#:site'
    match ':site/view_setting/:action' => 'view_setting#:action#:site'
    # Widgets setting
    match ':site/widgets' => 'widgets#index#:site'
    match ':site/widgets/:action/:id' => 'widgets#:action#:id#:site'
    match ':site/widgets/:action' => 'widgets#:action#:site'

    match ':site/text_widget/:action/:id' => 'text_widget#:action#:id#:site'
    match ':site/company_profile_widget/:action/:id' => 'company_profile_widget#:action#:id#:site'

    # Inquiry Item setting
    match ':site/inquiry_items/:action/:id' => 'inquiry_items#:action#:id#:site'
    match ':site/inquiry_items/:action' => 'inquiry_items#:action#:site'
    
    match ':site/text_inquiry_item/:action/:id' => 'text_inquiry_item#:action#:id#:site'
    match ':site/radio_inquiry_item/:action/:id' => 'radio_inquiry_item#:action#:id#:site'
    match ':site/checkbox_inquiry_item/:action/:id' => 'checkbox_inquiry_item#:action#:id#:site'
    match ':site/email_inquiry_item/:action/:id' => 'email_inquiry_item#:action#:id#:site'


    # Images
    match ':site/images' => 'images#index#:site'
    match ':site/images/:action/:id' => 'images#:action#:id#:site'
    match ':site/images/:action' => 'images#:action#:site'
    
    # Informations
    match ':site/informations/:action/:id' => 'informations#:action#:id#:site'
    
    # dashboard
    match ':site/dashboard/:action' => 'dashboard#:action#:site'
    match ':site/dashboard' => 'dashboard#index#:site'

    # password
    match ':site/password' => 'password#index#:site'
    match ':site/password/:action/:id' => 'password#:action#:id#:site'
    match ':site/password/:action' => 'password#:action#:site'

    
    # default - dashboard
    match ':site' => 'dashboard#index#:site'
    match '/' => 'dashboard#index'
    
    resources :users
  end

#  resources :articles
  
#  root :to => 'home#show'
  
  match 'sitemap.:format' => 'sitemap#index#:format'
  

  # pages
#  match 'pages/:site/:page' => 'pages#show#:site#:page'
  match ':site/pages/preview' => 'pages#preview#:site'
  match ':site/pages/:page' => 'pages#show#:site#:page'
  match ':site/pages/:action/:id' => 'pages#:action#:site#:id'



  # blogs
  match ':site/blogs/:id' => 'blogs#show#:site#:id'
  match ':site/blogs/month/:month' => 'blogs#month#:site#:month'
  match ':site/blogs/:action/:id' => 'blogs#:action#:site#:id'

  # article (sitemap , rss, atom ..)
  match ':site/articles/index.:format' => 'articles#index#:format#:site'
  match ':site/articles/index' => 'articles#index'
  match ':site/articles/:action/:id' => 'articles#:action#:id#:site'
#  match ':site/articles/index.:format' => 'articles#index.:format#:site'

  # inquiry
  match ':site/inquiry' => 'inquiry#index#:site'
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
