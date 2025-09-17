class Fcm::SubscribeToTopic
  attr_reader :fcm

  def initialize
    @fcm = FCM.new(Rails.configuration.fcm_server_key)
  end

  def perform(fcm_token, topic)
    response = fcm.topic_subscription(topic, fcm_token)
  end
end
