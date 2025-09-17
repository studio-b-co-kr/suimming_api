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
  end
end
