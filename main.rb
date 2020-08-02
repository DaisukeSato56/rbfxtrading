# frozen_string_literal: true

require './settings'

require './oanda/oanda'

def main
  settings = Settings.new
  api_client = APIClient.new(settings.access_token, settings.account_id)
  ticker = api_client.get_ticker(settings.product_code)
  puts ticker.volume
end

main if __FILE__ == $PROGRAM_NAME
