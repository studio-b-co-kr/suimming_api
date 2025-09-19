require 'shellwords'

class SubmitSuiTransaction
  def self.call(side:, price:, quantity:, symbol:, exchange:, filled_at:, timestamp:)
    private_key = ENV['SUI_PRIVATE_KEY']
    package_id = ENV['SUI_PACKAGE_ID']
    book_id = ENV['TRANSACTION_BOOK_ID']
    script_path = Rails.root.join('node', 'submit_transaction.js')

    args = [script_path.to_s, book_id, side, price, quantity, symbol, exchange, filled_at, timestamp, private_key, package_id]
    cmd = ['node', *args].shelljoin  # properly quoted

    result = `#{cmd}`
    if $?.success?
      JSON.parse(result)
    else
      raise "Sui transaction failed: #{result}"
    end
  end
end