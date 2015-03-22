Hondana::Application.routes.draw do
  post "information/send_mail" => "information#send_mail", format: false
  get "information/:action" => "information#:action", format: false

  get "messages" => "messages#index", format: false
  post "messages/read" => "messages#read"

  get "members" => "members#index", format: false
  post "members/login" => "members#authenticate", format: false
  post "members/confirm" => "members#confirm", format: false
  post "members/create" => "members#create", format: false
  post "members/send_mail_token" => "members#send_mail_token", format: false
  post "members/reset_password" => "members#reset_password", format: false
  patch "members/update" => "members#update", format: false
  patch "members/update_password" => "members#update_password", format: false
  get "members/login_as/:id" => "members#login_as", format: false
  get "members/:action" => "members#:action", format: false

  get "back" => "application#back", format: false

  get "books/list" => "books#list", format: false
  get "books/search" => "books#search", format: false
  get "books/search_edit" => "books#search_edit", format: false
  get "books/search_detail" => "books#search_detail", format: false
  post "books/favorite" => "books#favorite", format: false
  get "books/delete_favorite" => "books#delete_favorite", format: false
  get "books/show_image/:isbn" => "books#show_image", format: false

  get "collections" => "collections#index", format: false
  get "collections/index" => "collections#index", format: false
  get "collections/new" => "collections#new", format: false
  get "collections/list" => "collections#list", format: false
  post "collections/confirm" => "collections#confirm", format: false
  post "collections/create" => "collections#create", format: false
  get "collections/complete" => "collections#complete", format: false
  get "collections/edit" => "collections#edit", format: false
  patch "collections/update" => "collections#update", format: false
  get "collections/member_list" => "collections#member_list", format: false
  get "collections/confirm_request" => "collections#confirm_request", format: false
  get "collections/destroy" => "collections#destroy", format: false
  post "collections/request_collection" => "collections#request_collection", format: false
  get "collections/download_label" => "collections#download_label", format: false
  post "collections/complete_sending" => "collections#complete_sending", format: false
  get "collections/:id" => "collections#show", format: false

  resources :books, format: false
  resources :notices, format: false
  resources :genres, format: false

  root 'information#top'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
