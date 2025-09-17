class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  validates :wallet_address, uniqueness: true, allow_blank: false

  def on_jwt_dispatch(_token, payload)
    @token = _token
    JwtDenylist.create!(
      jti: payload['jti'],
      exp: Time.zone.at(payload['exp']),
      user_id: id,
    )
  end

end
