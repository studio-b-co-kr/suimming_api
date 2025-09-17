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

    resources :demo, only: [] do
      collection do
        get :campaigns
      end
      member do
        get :campaign
      end
    end

    # Nested route for trades within campaigns
    get '/demo/campaigns/:id', to: 'demo#campaign'
    post '/demo/campaigns/:campaign_id/trades', to: 'demo#create_trade'
  end
end
