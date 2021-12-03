Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :destroy, :update]
        post "/sign_up", to: "users#create"
        post "/login", to: "authentication#login"

    end
  end

  #redirect all other requests to not found
  get '/*a', to: 'application#not_found'
  
end
