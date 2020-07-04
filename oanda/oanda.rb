# frozen_string_literal: true

require 'oanda_api_v20'

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
end
