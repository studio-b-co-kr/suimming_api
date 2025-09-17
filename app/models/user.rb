class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_many :sso_identities, dependent: :destroy
  has_many :fcm_identities, dependent: :destroy
  validates :email, uniqueness: true, allow_blank: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }, if: :validate_email_sign?
  validates :password, presence: true, length: { minimum: 8 }, if: :validate_email_sign?

  def on_jwt_dispatch(_token, payload)
    @token = _token
    JwtDenylist.create!(jti: payload['jti'], exp: Time.zone.at(payload['exp']))
  end

  def self.find_or_create_by_sso(email:, provider:, uid:)
    uid = uid.to_s
    provider = SsoIdentity.providers[provider]
    user = includes(:sso_identities)
           .references(:sso_identities)
           .find_by('(email = ? AND email IS NOT NULL AND email != \'\') OR
                     (sso_identities.provider = ? AND sso_identities.uid = ?)',
                    email, provider, uid)
    return user if user.present?

    user = new(email: email)
    user.sso_identities.build(provider: provider, uid: uid)
    user.save!
    user
  end

  def validate_email_sign!
    @validate_email_sign = true
  end

  private

  def validate_email_sign?
    @validate_email_sign
  end
end
