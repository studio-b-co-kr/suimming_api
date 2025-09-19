class RestClients::BithumbRestClient
  # docs at https://apidocs.bithumb.com/
  # rate limit of public 150/s, private 140/s
  # tickers: KRW-BTC
  attr_reader :key, :secret
  BASE_URL = 'https://api.bithumb.com'

  def initialize(key, secret)
    @key = key
    @secret = secret
  end

  def exchange
    'bithumb'
  end

  def header_params(query_params)
    payload = {
      'access_key': key,
      'nonce': SecureRandom.uuid,
      'timestamp': (DateTime.current.to_f * 1000).round.to_s
    }
    if query_params.present?
      hash = Digest::SHA512.new
      query_hash = hash.hexdigest(query_params)
      payload.merge!('query_hash' => query_hash, 'query_hash_alg' => 'SHA512')
    end

    token = JWT.encode(payload, secret)
    {
      'Authorization' => "Bearer #{token}",
      'Accept' => 'application/json',
      'Content-Type' => 'application/json; charset=utf-8'
    }
  end

  def up
    ticker('KRW-ETH')
    true
  rescue => e
    false
  end

  def handle_error(response_body, args={})
    # on open orders, or order specific call
    if response_body.to_s =~ /거래 진행중인 내역이 존재하지 않습니다/
      response_body['data'] = []
      if args[:api] =~ /order_transactions/
        response_body['data'] = {}
        response_body['data']['contract'] = []
      end
      return
    end
    if response_body.to_s =~ /주문내역이 존재하지 않습니다/
      response_body['data'] = {}
      response_body['data']['contract'] = []
      return
    end
    return if response_body.to_s =~ /대기주문이 없습니다|order_not_found/i # not a problem

    raise Errors::BalanceError.new("Insufficient balance on bithumb order: #{response_body}") if response_body.to_s =~ /ORDER_002|insufficient_funds/i
    raise Errors::BalanceError.new("Insufficient balance on bithumb balance: #{response_body}") if response_body.to_s =~ /FUND_002/i
    raise Errors::MiscError.new("Error: #{response_body}") if response_body.is_a?(Hash) && response_body['error'].present?
  end

  # public api

  # ticker
  def ticker(symbol)
    params = "markets=#{symbol}"
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/ticker?#{params}"
      )
    )
    handle_error(body)

    body
  end

  # upto 30 hokas
  def order_book(symbol)
    params = "markets=#{symbol}"
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/orderbook?#{params}"
      )
    )
    handle_error(body)

    body
  end

  # transactions
  # count 1-100 default 20
  def trades(symbol)
    params = "market=#{symbol}&count=100"
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/trades/ticks?#{params}"
      )
    )
    handle_error(body)

    body
  end

  # 한국시간 기준
  # unit in minutes 1, 3, 5, 10, 15, 30, 60, 240
  def kline(symbol:, end_time:, interval:, limit: 200)
    params = {
      count: limit, # max 200
      market: symbol,
      to: end_time.strftime('%Y-%m-%dT%H:%M:%S')
    }
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/candles/minutes/#{interval}",
        params: params
      )
    )
    raise Errors::MiscError.new("Error: #{body}") if !body.is_a?(Array)

    body
  end

  def day_kline(symbol:, end_time:, limit: 200)
    params = {
      count: limit, # max 200
      market: symbol,
      to: end_time.strftime('%Y-%m-%dT%H:%M:%S')
    }
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/candles/days",
        params: params
      )
    )
    raise Errors::MiscError.new("Error: #{body}") if !body.is_a?(Array)

    body
  end


  # private

  def balances
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/accounts",
        headers: header_params('')
      )
    )
    handle_error(body)

    body
  end

  # wait, watch, done, cancel (watch cant be used with wait,done,cancel)
  def my_open_orders(symbol, page=1)
    params = "market=#{symbol}&states[]=wait&page=#{page}&limit=100&order_by=desc"
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/orders?#{params}",
        headers: header_params(params)
      )
    )
    handle_error(body)

    body
  end

  def my_closed_orders(symbol, page=1)
    params = "market=#{symbol}&states[]=done&states[]=cancel&page=#{page}&limit=100&order_by=desc"
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/orders?#{params}",
        headers: header_params(params)
      )
    )
    handle_error(body)

    body
  end

  def my_order(order_id)
    params = { uuid: order_id }
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/order",
        params: params,
        headers: header_params(params.to_query)
      )
    )
    handle_error(body)

    body
  end

  # searchGb: 0 : All, 1 : Bought, 2 : Sold, 3 : Withdraw in progress
  # 4 : deposit, 5 : withdraw, 9 : deposit KRW in progress
  # count 1-50
  # note this isnt just order txs, it include deposit/withdraw
  # def my_trades(offset:, limit:, search_type:, order_currency:)
  #   params = { endpoint: '/info/user_transactions', order_currency: order_currency }
  #   params.merge!(count: limit) if limit.present?
  #   params.merge!(offset: offset) if offset.present?
  #   headers = header_params(signature(params, '/info/user_transactions', timestamp))
  #   @timestamp = nil
  #   body = JSON.parse(
  #     TyphoeusBody.post(
  #       url: "#{BASE_URL}/info/user_transactions",
  #       body: params,
  #       headers: headers
  #     )
  #   )
  #   handle_error(body)

  #   body
  # end

  def create_order(symbol:, quantity:, price:, side:, order_type: 'limit')
    side_type = if side =~ /buy/
      'bid'
    elsif side =~ /sell/
      'ask'
    end
    ord_type = if order_type =~ /limit/
      'limit'
    elsif order_type =~ /market/ && side =~ /buy/
      'price'
    elsif order_type =~ /market/ && side =~ /sell/
      'market'
    end

    # must be in order
    params = {
      market: symbol,
      ord_type: ord_type,
      price: price.to_d.to_s('F'), # 지정가, 시장가 매수 시 필수
      side: side_type,
      volume: quantity.to_d.to_s('F') # 지정가, 시장가 매도 시 필수
    }

    params.delete(:price) if ord_type =~ /market/ # 시장가 매도
    if ord_type =~ /price/ # 시장가 매수
      orderbook = order_book(symbol).find{|ob| ob['market'] == symbol}
      first_ask_hoka = orderbook['orderbook_units'][0]['ask_price'].to_d
      params[:price] = (first_ask_hoka * params[:volume].to_d).to_s('F')
      params.delete(:volume)
    end

    body = JSON.parse(
      TyphoeusBody.post(
        url: "#{BASE_URL}/v1/orders",
        body: params.to_json,
        headers: header_params(params.to_query)
      )
    )
    handle_error(body)

    body
  end

  def cancel_order(order_id:)
    params = { order_id: order_id }
    body = JSON.parse(
      TyphoeusBody.delete(
        url: "#{BASE_URL}/v2/order?#{params.to_query}",
        headers: header_params(params.to_query),
        allow_regex: /order_not_found/
      )
    )
    handle_error(body)

    body
  end

  def gt_min_withdraw_quantity?(currency, quantity)
    (currency.downcase == 'btc' && quantity >= 0.002) ||
      (currency.downcase == 'eth' && quantity >= 0.01) ||
      (currency.downcase == 'orbs' && quantity >= 24) ||
      (currency.downcase == 'sol' && quantity >= 0.06) ||
      (currency.downcase == 'usdt' && quantity >= 0.000001) ||
      (currency.downcase == 'usdc' && quantity >= 23)
  end

  # https://apidocs.bithumb.com/reference/%EC%BD%94%EC%9D%B8-%EC%B6%9C%EA%B8%88%ED%95%98%EA%B8%B0-%EA%B0%9C%EC%9D%B8
  # 개인, address - wallet address, destination on some chains, currency
  # min withdraw amounts https://apidocs.bithumb.com/reference/%EC%BD%94%EC%9D%B8-%EC%B6%9C%EA%B8%88-%EC%B5%9C%EC%86%8C%EC%88%98%EB%9F%89-%EC%95%88%EB%82%B4
  # 02/09/2024 -> BTC : 0.002, ETH : 0.01, ORBS : 24, SOL : 0.06, USDT : 0.000001, USDC: 23
  # exchange codes https://www.bithumb.com/customer_support/info_guide?seq=4903&categorySeq=609
  # fees https://www.bithumb.com/react/info/fee/inout
  WHITELIST_CURRENCIES = %w(BTC ETH ORBS SOL USDT USDC)
  WHITELIST_EXCHANGES = %w(Bitget Bybit LBANK OKX Upbit)
  NET_TYPES = {
    'ORBS' => 'ETH',
    'USDT' => 'TRX',
    'SOL' => 'SOL'
  }
  def withdraw(address:, currency:, korean_name:, english_name:, exchange_name:, quantity:)
    selected_currency = WHITELIST_CURRENCIES.find{|cur| cur == currency.upcase}
    raise "Invalid currency #{currency}" if selected_currency.blank?
    selected_exchange_name = WHITELIST_EXCHANGES.find{|ex| ex.downcase == exchange_name.downcase}
    raise "Invalid exchange name #{exchange_name}" if selected_exchange_name.blank?
    raise "Min withdraw quantity not enough #{currency} #{quantity}" if !gt_min_withdraw_quantity?(currency, quantity)

    net_type = NET_TYPES[selected_currency]
    receiver_type = 'personal'
    params = {
      address: address.strip,
      amount: quantity,
      currency: selected_currency,
      exchange_name: selected_exchange_name,
      net_type: net_type,
      receiver_en_name: english_name,
      receiver_ko_name: korean_name,
      receiver_type: receiver_type
    }
    body = JSON.parse(
      TyphoeusBody.post(
        url: "#{BASE_URL}/v1/withdraws/coin",
        body: params.to_json,
        headers: header_params(params.to_query)
      )
    )
    handle_error(body)

    body
  end

  def my_coin_withdraws()
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/withdraws",
        headers: header_params('')
      )
    )
    handle_error(body)

    body
  end

  def my_coin_withdraw_addresses()
    body = JSON.parse(
      TyphoeusBody.get(
        url: "#{BASE_URL}/v1/withdraws/coin_addresses",
        headers: header_params('')
      )
    )
    handle_error(body)

    body
  end

  ### common methods
  def update_symbol_info(symbol)
    puts "no auto update for bithumb"
  end

  def usdt_price(reference = 'mid')
    body = order_book('KRW-USDT').find{|ob| ob['market'] == 'KRW-USDT'}

    ask = body['orderbook_units'][0]['ask_price'].to_d
    bid = body['orderbook_units'][0]['bid_price'].to_d

    if reference == 'mid'
      (bid + ask) / 2.0
    elsif reference == 'ask'
      ask
    elsif reference == 'bid'
      bid
    elsif reference == 'spread'
      { 'bid' => bid, 'ask' => ask }
    end
  end

  def usdc_price(reference = 'mid')
    body = order_book('KRW-USDC').find{|ob| ob['market'] == 'KRW-USDC'}

    ask = body['orderbook_units'][0]['ask_price'].to_d
    bid = body['orderbook_units'][0]['bid_price'].to_d

    if reference == 'mid'
      (bid + ask) / 2.0
    elsif reference == 'ask'
      ask
    elsif reference == 'bid'
      bid
    elsif reference == 'spread'
      { 'bid' => bid, 'ask' => ask }
    end
  end

  def btc_price(reference = 'mid')
    body = order_book('KRW-BTC').find{|ob| ob['market'] == 'KRW-BTC'}

    ask = body['orderbook_units'][0]['ask_price'].to_d
    bid = body['orderbook_units'][0]['bid_price'].to_d

    if reference == 'mid'
      (bid + ask) / 2.0
    elsif reference == 'ask'
      ask
    elsif reference == 'bid'
      bid
    elsif reference == 'spread'
      { 'bid' => bid, 'ask' => ask }
    end
  end

  def formatted_order_book(symbol, limit=5)
    data = order_book(symbol).find{|ob| ob['market'] == symbol}['orderbook_units']
    {
      'asks' => data.map{|o| { 'price' => o['ask_price'].to_d, 'quantity' => o['ask_size'].to_d }}.sort_by{|o| o['price']},
      'bids' => data.map{|o| { 'price' => o['bid_price'].to_d, 'quantity' => o['bid_size'].to_d }}.sort_by{|o| o['price']}.reverse,
      'updated_at' => Time.current
    }
  end

  def formatted_kline(symbol:, interval:, limit:, after:, before:)
    if interval == '1d'
      body = day_kline(symbol: symbol, end_time: after, limit: [limit, 200].min)
    else
      formatted_interval = case interval
      when '1H'
        60 # 60 min
      when '10m'
        10
      else
        5
      end
      body = kline(symbol: symbol, end_time: after, interval: formatted_interval, limit: [limit, 200].min)
    end 
    return [] if body.blank?
    
    #bithumb day kline return kst 00:00
    body.select{ |k| before < Time.zone.parse(k['candle_date_time_kst']) && Time.zone.parse(k['candle_date_time_kst']) <= after }.map do |d|
      {
        time: Time.zone.parse(d['candle_date_time_kst']),
        open: d['opening_price'].to_d,
        high: d['high_price'].to_d,
        low: d['low_price'].to_d,
        close: d['trade_price'].to_d,
        volume: d['candle_acc_trade_volume'].to_d #trading volume in base currency 
      }.with_indifferent_access
    end
  end

  def formatted_balances()
    body = balances()
    {
      'currencies' => body.map do |currency|
        available = currency['balance'].to_d
        frozen = currency['locked'].to_d
        total = available + frozen
        {
          'currency' => currency['currency'].downcase,
          'available' => available,
          'display_available' => available.to_s('F'),
          'frozen' => frozen,
          'display_frozen' => frozen.to_s('F'),
          'total' => total,
          'display_total' => total.to_s('F')
        }
      end,
      'updated_at' => Time.current,
      'raw' => body
    }
  end

  def formatted_create_order(symbol:, side:, price:, quantity:, order_type:, make_only: false)
    body = create_order(symbol: symbol, quantity: quantity, price: price, side: side, order_type: order_type)
    {
      'order_id' => body['uuid'].to_s
    }
  end

  def formatted_order(symbol, order_id='')
    if order_id.present?
      body = my_order(order_id)
      order_status = case body['state']
      when /wait|watch/i
        'pending'
      when /cancel/i
        'cancelled'
      when /done/i
        'filled'
      else
        'pending'
      end
      quote_currency = symbol.split('-')[0]
      transaction_time = if body['trades'].present?
        Time.zone.parse(body['trades'][-1]['created_at'])
      end
      filled_quantity = body['trades'].reduce(0){|sum, n| sum + n['volume'].to_d}
      filled_value = body['trades'].reduce(0){|sum, n| sum + (n['price'].to_d * n['volume'].to_d)}
      filled_price = filled_quantity.zero? ? 0 : filled_value / filled_quantity
      fee = body['paid_fee'].to_d
      fee_currency = quote_currency.downcase
      remaining_quantity = body['remaining_volume'].to_d
      order_status = 'filled' if filled_quantity > 0 && body['remaining_volume'].to_d.zero?
      completed_on = if ['cancelled', 'filled'].include?(order_status)
        if transaction_time.present?
          transaction_time.to_date
        else
          Date.current # not accurate
        end
      else
        nil
      end
      remaining_quantity = 0 if completed_on.present?
      side = if body['side'] =~ /bid/i
        'buy'
      elsif body['side'] =~ /ask/i
        'sell'
      else
      end

      formatted_trades = []
      body['trades'].each do |item|
        hsh = {}
        hsh['filled_price'] = item['price'].to_d
        hsh['filled_quantity'] = item['volume'].to_d
        hsh['quote_filled_quantity'] = item['price'].to_d * item['volume'].to_d
        hsh['trade_time'] = Time.zone.parse(item['created_at'])
        hsh['fee'] = 0 # missing on tx level
        hsh['fee_coin'] = quote_currency.downcase
        hsh['order_id'] = order_id
        hsh['transaction_id'] = item['uuid']
        hsh['client_type'] = client_type
        hsh['actual_type'] = ''
        hsh['side'] = body['side'] == 'ask' ? 'sell' : 'buy'
        formatted_trades << hsh
      end

      {
        'order_id' => order_id.to_s,
        'price' => body['price'].to_d,
        'remaining_quantity' => remaining_quantity,
        'side' => side,
        'filled_quantity' => filled_quantity,
        'filled_price' => filled_price,
        'fee' => fee,
        'fee_coin' => fee_currency,
        'filled_at' => transaction_time,
        'cancelled_at' => cancelled_at, # dont set this since api doesnt return this
        'fees' => [{ 'fee' => fee, 'fee_coin' => fee_currency }],
        'status' => order_status,
        'completed_on' => completed_on,
        'trades' => formatted_trades
      }
    else
      {}
    end
  end

  def formatted_open_orders(symbol)
    body = my_open_orders(symbol)
    body.map do |item|
      {
        'order_id' => item['uuid'].to_s,
        'price' => item['price'].to_d,
        'quantity' => item['remaining_volume'].to_d,
        'side' => item['side'] == 'ask' ? 'sell' : 'buy'
      }
    end
  end

  def formatted_trades(symbol, client_type, order_ids)
    trades = []
    quote_currency = symbol.split('-')[0]
    order_ids.each do |order_id|
      body = my_order(order_id)
      sleep(0.1)
      body['trades'].each do |item|
        hsh = {}
        hsh['filled_price'] = item['price'].to_d
        hsh['filled_quantity'] = item['volume'].to_d
        hsh['quote_filled_quantity'] = item['price'].to_d * item['volume'].to_d
        hsh['trade_time'] = Time.zone.parse(item['created_at'])
        hsh['fee'] = 0 # missing on tx level
        hsh['fee_coin'] = quote_currency.downcase
        hsh['order_id'] = order_id
        hsh['transaction_id'] = item['uuid']
        hsh['client_type'] = client_type
        hsh['actual_type'] = ''
        hsh['side'] = body['side'] == 'ask' ? 'sell' : 'buy'
        trades << hsh
      end
    end

    trades
  end

  def upcoming_maintenance_announcements
    es = ExchangeSetting.where(active: true)
    coins = es.map(&:coin).map(&:upcase)
    coins = coins + es.map(&:quote_currency).map(&:upcase)
    coins = coins.select{|d| d.present?}.uniq
    regex_string = "/투자유의|거래지원종료|점검|#{coins.join('|')}/"
    items = []
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0'
    page1 = Nokogiri::HTML(URI.open('https://feed.bithumb.com/notice?page=1', 'User-Agent' => user_agent))
    links = page1.xpath(".//ul[contains(@class, 'ContentList')]/li/a")
    links.map do |link|
      spans = link.xpath('.//span')
      content = spans[0].text
      date = Date.parse(spans[1].text)
      {
        exchange: 'bithumb',
        content: content,
        link: "https://feed.bithumb.com/notice#{link.attr('href')}",
        date: date
      }
    end.select{|d| d[:content] =~ Regexp.new(regex_string)}

  end
end
