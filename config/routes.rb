Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show]
        post "/sign_up", to: "users#create"
        post "/login", to: "authentication#login" 
        get "/auto_login", to: "users#auto_login"
    end
  end
end
