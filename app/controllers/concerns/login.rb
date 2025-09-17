# frozen_string_literal: true

module Login
  extend ActiveSupport::Concern

  private

  def login_response_json(resource)
    token = resource.instance_variable_get('@token')
    if params[:device_id].present? && params[:fcm_token].present?
      FcmTokenService.new(user_id: resource.id,
                          device_id: params[:device_id],
                          token: params[:fcm_token])
                     .generate
    end
    latest_version = Version.last
    {
      user_id: resource.id,
      access_token: token,
      fcm_token: params[:fcm_token],
      device_id: params[:device_id],
      version: {
        latest_version: latest_version.latest_version,
        minimum_version: latest_version.minimum_version,
        released_at: latest_version.released_at
      }
    }
  end
end
