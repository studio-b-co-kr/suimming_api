module V1
  module Users
    class SsoSessionsController < ApplicationController
      include Login
      before_action :authenticate_request!, only: %i[token logout]

      def create
        user = SsoLoginService.new(provider: params[:sso_provider],
                                   access_token: params[:sso_access_token])
                              .perform
        if user
          token, payload = Warden::JWTAuth::UserEncoder.new
                                                       .call(user, :users, nil)
          user.on_jwt_dispatch(token, payload)
          render json: login_response_json(user)
        else
          render json: { errors: 'Not Authenticated' }, status: :unauthorized
        end
      end

      def token
        User.revoke_jwt(@payload, current_user)
        token, payload = Warden::JWTAuth::UserEncoder.new
                                                     .call(current_user, :users, nil)
        user.on_jwt_dispatch(token, payload)
        render json: { access_token: token, user_id: user_id }
      end

      def logout
        sign_out(current_user)
        render json: { user_id: user_id }
      end
    end
  end
end
