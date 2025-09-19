module ExchangeSettingHelpers::ClientHelper
  extend self

  def private_client
    case exchange
    when 'bithumb'
      RestClients::BithumbRestClient.new(access_key, secret_key)
    else
      raise "Missing exchange private client #{exchange}"
    end
  end

  def public_client
    case exchange
    when 'bithumb'
      RestClients::BithumbRestClient.new('', '')
    else
      raise "Missing exchange public client #{exchange}"
    end
  end
end
