module V1
  module Users
    class RegistrationsController < Devise::RegistrationsController
      include Login
      respond_to :json
      skip_before_action :authenticate_request!

      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]

      def create
        I18n.locale = :ko
        build_resource(sign_up_params)
        resource.validate_email_sign!
        if resource.save
          sign_in(resource_name, resource)
          render json: login_response_json(resource)
        else
          render json: { errors: resource.errors }, status: :bad_request
        end
      end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_up_params
      #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
      # end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_account_update_params
      #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
      # end

      # The path used after sign up.
      def after_sign_up_path_for(resource)
        super(resource)
      end

      # The path used after sign up for inactive accounts.
      def after_inactive_sign_up_path_for(resource)
        super(resource)
      end

      private

      def current_user
        resource
      end
    end
  end
end
