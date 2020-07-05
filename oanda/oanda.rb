# frozen_string_literal: true

require 'oanda_api_v20'

class Ticker
  attr_accessor :product_code, :timestamp, :bid, :ask, :volume

  def initialize(product_code, timestamp, bid, ask, volume)
    @product_code = product_code
    @timestamp = timestamp
    @bid = bid
    @ask = ask
    @volume = volume
  end
end

class Balance
  attr_accessor :currency, :available

  def initialize(currency, available)
    @currency = currency
    @available = available
  end
end

class APIClient
  def initialize(access_token, account_id, environnment = 'practice')
    @access_token = access_token
    @account_id = account_id
    @client = OandaApiV20.new(access_token: access_token, practice: environnment == 'practice')
  end

  def get_balance
    begin
      resp = @client.account(@account_id).summary.show
    rescue StandardError => e
      raise e
    end
    available = resp['account']['balance'].to_f
    currency = resp['account']['currency']
    Balance.new(currency, available)
  end

  def get_ticker(product_code)
    params = {
      'instruments': product_code
    }
    req = @client.account(@account_id).pricing(params)
    begin
      resp = req.show
    rescue StandardError => e
      raise e
    end
    timestamp = Time.parse(resp['time'])
    price = resp['prices'][0]
    instrument = price['instrument']
    bid = price['bids'][0]['price'].to_f
    ask = price['asks'][0]['price'].to_f
    volume = 11_111
    Ticker.new(instrument, timestamp, bid, ask, volume)
  end
end
