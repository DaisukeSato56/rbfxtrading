# frozen_string_literal: true

require './settings'

def main
  settings = Settings.new
  puts settings.account_id
  puts settings.account_token
end

main if __FILE__ == $PROGRAM_NAME
