# frozen_string_literal: true

require './settings'

require './oanda/oanda'

def main
  settings = Settings.new
  api_client = APIClient.new(settings.access_token, settings.account_id)
  ticker = api_client.get_ticker(settings.product_code)
  puts ticker.product_code
  puts ticker.ask
  puts ticker.timestamp
  puts ticker.truncate_date_time('5s')
  puts ticker.truncate_date_time(settings.trade_duration)
  puts ticker.truncate_date_time('1h')
end

main if __FILE__ == $PROGRAM_NAME
