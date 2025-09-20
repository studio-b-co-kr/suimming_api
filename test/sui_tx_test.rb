require 'test_helper'

class SubmitSuiTransactionTest < ActiveSupport::TestCase
  setup do
    @side = "buy"
    @price = 5000.to_s
    @quantity = 1.to_s
    @symbol = "KRW-SUI"
    @exchange = "bithumb"
    @filled_at = Time.now.to_i
    @timestamp = Time.now.to_i
  end

  test "calls node script with correct arguments and parses JSON on success" do
    
    result = SubmitSuiTransaction.call(side: @side, price: @price, quantity: @quantity, symbol: @symbol, exchange: @exchange, filled_at: @filled_at, timestamp: @timestamp)
    
    puts "✅ Result from node script: #{result.inspect}"
    # Result from node script: {"digest"=>"7ZZC9PhS8VmbBKrvgEQmsUeMqBHG1fdArYBNpJTkPm26", "confirmedLocalExecution"=>false}
    # digest is like a transaction hash on Ethereum
  end

end

# rails test file: test/sui_tx_test.rb
