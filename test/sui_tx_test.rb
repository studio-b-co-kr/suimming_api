require 'test_helper'

class SubmitSuiTransactionTest < ActiveSupport::TestCase
  setup do
    @message = "Test message3"
    @timestamp = Time.now.to_i
  end

  test "calls node script with correct arguments and parses JSON on success" do
    
    result = SubmitSuiTransaction.call(message: @message, timestamp: @timestamp)
    
    puts "✅ Result from node script: #{result.inspect}"
    # Result from node script: {"digest"=>"7ZZC9PhS8VmbBKrvgEQmsUeMqBHG1fdArYBNpJTkPm26", "confirmedLocalExecution"=>false}
    # digest is like a transaction hash on Ethereum
  end

end

# rails test file: test/sui_tx_test.rb
