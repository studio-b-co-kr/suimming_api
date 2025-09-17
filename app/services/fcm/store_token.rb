class Fcm::StoreToken
  attr_reader :user_id, :device_id, :token

  def initialize(user_id:, device_id:, token:)
    @user_id = user_id
    @device_id = device_id
    @token = token
  end

  def perform
    FcmIdentity.transaction do
      old_fcm_identity = FcmIdentity.find_by(active: true,
                                             user_id: user_id,
                                             device_id: device_id)
      old_fcm_identity.update(active: false) if old_fcm_identity.present?
      FcmIdentity.create!(active: true,
                          user_id: user_id,
                          device_id: device_id,
                          token: token)
    end
  end
end
