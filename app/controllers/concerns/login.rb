# frozen_string_literal: true

module Login
  extend ActiveSupport::Concern

  private

  def login_response_json(resource)
    token = resource.instance_variable_get('@token')
    latest_version = Version.last
    {
      wallet_address: resource.wallet_address,
      access_token: token
    }
  end
end
