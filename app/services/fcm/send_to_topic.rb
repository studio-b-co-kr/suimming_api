class Fcm::SendToTopic
  attr_reader :fcm

  def initialize
    @fcm = FCM.new(Rails.configuration.fcm_server_key)
  end

  def perform(topic, message)
    response = fcm.send_to_topic(topic, data: { message: message })
  end
end
