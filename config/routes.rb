Rails.application.routes.draw do
  post '/register', to: 'users#register'
  post '/login', to: 'users#login'

  resources :posts do
    post '/add_tag', to: 'tags#add'
    delete '/remove_tag', to: 'tags#remove'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :posts, only: [:create, :update, :destroy]
    end
  end

  

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

end