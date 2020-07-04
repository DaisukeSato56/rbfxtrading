# frozen_string_literal: true

require './settings'

require './oanda/oanda'

def main
  settings = Settings.new
  api_client = APIClient.new(settings.access_token, settings.account_id)
  balance = api_client.get_balance
  puts balance.currency
  puts balance.available
end

main if __FILE__ == $PROGRAM_NAME
