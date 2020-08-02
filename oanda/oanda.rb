# frozen_string_literal: true

require 'oanda_api_v20'
require_relative '../settings.rb'
require_relative '../constants.rb'

class Ticker
  attr_accessor :product_code, :timestamp, :bid, :ask, :volume

  def initialize(product_code, timestamp, bid, ask, volume)
    @product_code = product_code
    @timestamp = timestamp
    @bid = bid
    @ask = ask
    @volume = volume
  end

  def mid_price
    (@bid + @ask) / 2
  end

  def time
    @timestamp.getutc
  end

  # [example]
  # 2020-01-02 03:04:27
  # 2020-01-02 03:04:25 5S
  # 2020-01-02 03:04:00 1M
  # 2020-01-02 03:00:00 1H
  def truncate_date_time(duration)
    ticker_time = time
    if duration == DURATION_5S
      new_sec = time.sec.floor / 5 * 5
      ticker_time = Time.new(
        time.year, time.month, time.day, time.hour, time.min, new_sec
      )
      time_format = '%Y-%m-%d %H:%M:%S'
    elsif duration == DURATION_1M
      time_format = '%Y-%m-%d %H:%M'
    elsif duration == DURATION_1H
      time_format = '%Y-%m-%d %H'
    else
      raise 'action=truncate_date_time error=no_datetime_format'
      nil
    end

    str_date = ticker_time.strftime(time_format)
    Time.strptime(str_date, time_format)
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
  attr_reader :settings

  def initialize(access_token, account_id, environnment = 'practice')
    @access_token = access_token
    @account_id = account_id
    @client = OandaApiV20.new(access_token: access_token, practice: environnment == 'practice')
    @settings = Settings.new
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
    volume = get_candle_volume
    Ticker.new(instrument, timestamp, bid, ask, volume)
  end

  def get_candle_volume(count = 1, granularity = TRADE_MAP[settings.trade_duration][:granularity])
    params = {
      'count': count,
      'granularity': granularity
    }
    req = @client.instrument(settings.product_code).candles(params)
    begin
      resp = req.show
    rescue StandardError => e
      raise e
    end

    resp['candles'][0]['volume']
  end
end
