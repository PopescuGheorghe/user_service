Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions,  :only => [:create, :destroy]
      resources :users,     :only => [:index, :show, :create, :update, :destroy]
    end
  end
end
