Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
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
    end
  end
end
