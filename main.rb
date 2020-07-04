# frozen_string_literal: true

require './settings'

def main
  settings = Settings.new
  puts settings.account_id
  puts settings.account_token
  puts settings.trade_num_ranking
end

main if __FILE__ == $PROGRAM_NAME
