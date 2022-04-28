Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, 
                               :update, :destroy]
        post "/sign_up", to: "users#create"
        post "/login", to: "authentication#login"

      resources :visits, only: [:index, :show, :create, 
                                :update, :destroy]
    end
  end

  #redirect all other requests to not found
  get '/*a', to: 'application#not_found'
  
end
