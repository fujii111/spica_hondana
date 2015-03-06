Hondana::Application.routes.draw do
  get "information/:action" => "information#:action", format: false
  get "members/:action" => "members#:action", format: false
  get "members" => "members#index", format: false
  get "members/login_as/:id" => "members#login_as", format: false
  post "members/login" => "members#authenticate", format: false
  post "members/confirm" => "members#confirm", format: false
  post "members/create" => "members#create", format: false
  patch "members/update" => "members#update", format: false
  resources :notices, format: false
  resources :genres, format: false
  get "books/list" => "books#list", format: false
  get "books/show_image/:isbn" => "books#show_image", format: false
  resources :books

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'books#list'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
