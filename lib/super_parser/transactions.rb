require_relative 'helper_methods'

class Transactions
  include HelperMethods

  attr_accessor :browser, :list, :list_jsoned

  def self.get_last_five(browser)
    new(browser)
  end

  def initialize(browser)
    @browser = browser
    get_transactions
  end

  def list
    @list ||= []
  end

  def list_jsoned
    @list_jsoned ||= []
  end

  private

  attr_accessor :transaction_details

  def get_transactions
    navigate_to('app.layout.DASHBOARD')
    sleep 2
    html_page = Nokogiri::HTML(browser.html)
    transaction_table_rows = html_page.css('table#lastFiveTransactions tbody tr')
    transaction_table_rows.each do |row|
      transaction_details_hash = {
          date: row.css('td')[1].text,
          description: row.css('td')[2].text,
          amount: row.css('td')[5].css('span').text.to_f
      }
      list_jsoned << hash_data(transaction_details_hash)
      transaction_details(transaction_details_hash)
    end
  end

  def transaction_details(details)
    list << details
  end
end
