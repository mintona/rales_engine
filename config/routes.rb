Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/random', to: 'random#show'
        get '/revenue', to: 'revenue#show'
        get '/most_revenue', to: 'revenue#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      resources :merchants, only: [:index, :show] do
        scope module: 'merchants' do
          resources :items, only: [:index]
          resources :invoices, only: [:index]
          get '/favorite_customer', to: 'customers#show'
        end
      end

      namespace :items do
        get '/random', to: 'random#show'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'revenue#index'
      end

      resources :items, only: [:index, :show] do
        scope module: 'items' do
          resources :invoice_items, only: [:index]
          get '/merchant', to: 'merchants#show'
          get '/best_day', to: 'revenue#show'
        end
      end

      resources :customers, only: [:index, :show] do
        scope module: 'customers' do
          resources :invoices, only: [:index]
          get '/favorite_merchant', to: 'merchants#show'
        end
      end
    end
  end
end
