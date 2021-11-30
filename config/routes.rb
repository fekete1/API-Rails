Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show], param: :name

      devise_for :users,
      defaults: { format: :json },
      path: '',
      path_names: {
        sign_in: '/login',
        sign_out: '/logout',
        registration: '/signup'
      },
      controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }
    end
  end
end
