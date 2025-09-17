class JsonFailureApp < Devise::FailureApp
  def respond
    json_error_response
  end

  def json_error_response
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = [{ message: i18n_message }].to_json
  end

  def i18n_options(options)
    options[:locale] = :ko
    options
  end
end
