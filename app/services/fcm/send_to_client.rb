class Fcm::SendToClient
  attr_reader :fcm

  def initialize
    @fcm = FCM.new(Rails.configuration.fcm_server_key)
  end

  # 1, upto 1000 fcm clients
  def perform(fcm_tokens, message)
    # See https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages for all available options.
    # options = { 'notification': {
    #               'title': title,
    #               'body': body } }
    # response is just a hash containing the response body, headers and status_code.
    # see https://firebase.google.com/docs/cloud-messaging/server#response for response params
    response = fcm.send(fcm_tokens, data: { message: message })
  end
end
