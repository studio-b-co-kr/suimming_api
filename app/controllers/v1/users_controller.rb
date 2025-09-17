class V1::UsersController < ApplicationController
    include Login
    skip_before_action :authenticate_request!, only: :connect
    
    def connect
        wallet_address = users_params[:wallet_address].downcase.strip
        wallet_type    = users_params[:wallet_type].downcase.strip

        user = User.find_or_initialize_by(wallet_address: wallet_address)
        user.wallet_type = wallet_type
        user.save!

        if user
            token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :users, nil)
            user.on_jwt_dispatch(token, payload)
                                                         
            render json: login_response_json(user)
        else
            render json: { errors: 'Not Authenticated' }, status: :unauthorized
        end

    end

    def disconnect
        puts current_user.id
        if current_user
            JwtDenylist.revoke_jwt(@payload, current_user)
            render json: { success: true }
        else
            render json: { error: 'Not Connected' }, status: :unauthorized
        end
    end
  

    def me
        if current_user
            render json: login_response_json(current_user)
        else
            render json: { errors: 'Not Authenticated' }, status: :unauthorized
        end
    end

    private
    def users_params
        params.permit(:wallet_address, :wallet_type)
    end
  end
  