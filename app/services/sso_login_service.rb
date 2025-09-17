# frozen_string_literal: true
# login from sso provider to get remedi user
class SsoLoginService
  attr_reader :provider, :access_token

  def initialize(provider:, access_token:)
    @provider = provider
    @access_token = access_token
  end

  def perform
    case provider
    when 'kakao'
      sso_user = KakaoUser.new(access_token).profile
      return nil if sso_user.blank?

      default_email = "kakao_#{sso_user[:id]}@#{ENV['DEFAULT_HOST']}"
      User.find_or_create_by_sso(provider: :kakao,
                                 uid: sso_user[:id].to_s,
                                 email: sso_user[:kakao_account][:email] || default_email)
    else raise "Unsupported provider: #{provider}"
    end
  rescue JWT::VerificationError, JWT::DecodeError => e
    Rails.logger.error "JWT decode error: #{e}"
  end
end
