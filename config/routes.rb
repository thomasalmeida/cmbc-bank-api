Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :accounts, only: [:create] do
        get 'balance', on: :collection
      end

      post 'auth/login', to: 'authentication#login'

      resources :transactions, only: %i[create index] do
        post 'reverse', on: :member
      end
    end
  end

  root to: 'application#not_found'
  match '*path', to: 'application#not_found', via: :all
end
