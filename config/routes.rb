Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions,  :only => [:create, :destroy]
      resources :users do
        get :me, on: :collection
      end
    end
  end
end
