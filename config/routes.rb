ContactGroup::Application.routes.draw do
  #resources :users 
  #match 'users/:id' => 'users#show'
  match 'users/' => 'users#index', :via => :get
  match 'user/profile/:id' => 'users#profile', :via => :get
  match 'user/pending_demands/:id' => 'users#pending_demands', :via => :get
  
  match 'categories/' => 'categories#index', :via => :get
  match 'category/:id' => 'categories#show', :via => :get
  match 'categories/published' => 'categories#published', :via => :get  
  match 'categories/publish/:id' => 'categories#publish', :via => :put
  
  match 'group/:id' => 'groups#show', :via => :get
  match 'group/publish/:id' => 'groups#publish', :via => :put
  match 'group/delete/:id' => 'groups#delete', :via => :put
  match 'group/category/:id' => 'groups#get_category', :via => :get
  match 'group/create' => 'groups#create', :via => :post
  match 'group/active_links/:id' => 'groups#show_active_links', :via => :get
  
  match 'demand/show/:id' => 'demands#show', :via => :get
  match 'demands/create' => 'demands#create', :via => :post
  match 'demands/accept' => 'demands#accept', :via => :put
  match 'demands/reject' => 'demands#reject', :via => :put
  
  match 'links/enable_message_reception' => 'links#enable_message_reception', :via => :put
  match 'links/disable_message_reception' => 'links#disable_message_reception', :via => :put
  
  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions", :confirmations => "confirmations"}
	
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
