# frozen_string_literal: true

require 'yaml'

class Settings
  attr_accessor :account_id, :access_token, :account_product_code, :db_name, :db_driver, :web_port, :trade_duration, :trade_back_test, :trade_use_percent, :trade_past_period, :trade_stop_limit_percent, :trade_num_ranking

  def initialize
    conf = YAML.load_file('settings.yml')
    @account_id = conf['oanda']['account_id']
    @access_token = conf['oanda']['access_token']
    @account_product_code = conf['oanda']['product_code']

    @db_name = conf['db']['name']
    @db_driver = conf['db']['driver']

    @web_port = conf['web']['port']

    @trade_duration = conf['rbtrading']['trade_duration'].downcase
    @trade_back_test = conf['rbtrading']['back_test']
    @trade_use_percent = conf['rbtrading']['use_percent']
    @trade_past_period = conf['rbtrading']['past_period']
    @trade_stop_limit_percent = conf['rbtrading']['stop_limit_percent']
    @trade_num_ranking = conf['rbtrading']['num_ranking']
  end
end
