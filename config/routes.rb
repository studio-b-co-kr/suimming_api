Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :v1, path: '/api/v1' do
    devise_for :users, skip: %i[sessions registrations]
    namespace :users do
      as :user do
        post    :sign_in,   to: 'sessions#create',       as: :user_session
        delete  :sign_out,  to: 'sessions#destroy',      as: :destroy_user_session
        post    :sign_up,   to: 'registrations#create',  as: :user_registration
      end
      resources :sso_sessions, only: :create do
        collection do
          post    :token
          delete  :logout
        end
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
  end
end
