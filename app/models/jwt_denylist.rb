class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  def self.jwt_revoked?(payload, _user)
    JwtDenylist.exists?(['jti = ? AND exp <= ?', payload['jti'], Time.current])
  end

  def self.revoke_jwt(payload, _user)
    JwtDenylist.find_by(jti: payload['jti'])
                .update(exp: Time.zone.now)
  end
end
