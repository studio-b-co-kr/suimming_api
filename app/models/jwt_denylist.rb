class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  def self.revoke_jwt(payload, _user)
    if (jwt = find_by(jti: payload['jti'], user_id: _user.id))
      jwt.update(exp: Time.zone.now)
    end
  end
end
