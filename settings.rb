# frozen_string_literal: true

require 'yaml'

class Settings
  attr_accessor :account_id, :account_token

  def initialize
    conf = YAML.load_file('setting.yml')
    @account_id = conf['oanda']['account_id']
    @account_token = conf['oanda']['access_token']
  end
end
