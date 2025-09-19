Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :v1, path: '/api/v1' do
    resources :users, only: [] do
      collection do
        post :connect
        delete :disconnect
        get :me
      end
    end

    resources :versions, only: [] do
      collection do
        get :latest
      end
    end
    
    resources :sui, only: [] do
      collection do
        post :submit_transaction
      end
    end
        
    resources :campaigns, only: [:index, :show] do
      member do
        get :my_summary
        get :my_open_orders
        get :my_executed_orders
      end
    end

    resources :campaign_orders, only: [:create] do
    end

  end
end
