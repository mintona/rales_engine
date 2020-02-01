Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/random', to: 'random#show'
        get '/most_revenue', to: 'revenue#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      resources :merchants, only: [:index, :show] do
        scope module: 'merchants' do
          resources :items, only: [:index]
          resources :invoices, only: [:index]
        end
      end

      namespace :items do
        get '/random', to: 'random#show'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      resources :items, only: [:index, :show] do
        scope module: 'items' do
          resources :invoice_items, only: [:index]
        end
      end
    end
  end
end
