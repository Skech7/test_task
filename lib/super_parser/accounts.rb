require_relative 'account'
require_relative 'helper_methods'

class Accounts
  include HelperMethods

  attr_accessor :browser, :list, :account_nature

  def self.get_from(browser)
    new(browser)
  end

  def initialize(browser)
    @browser = browser
    visit_accounts_page
    get_account_data
    visit_deposits_page
    get_account_data
    list
  end

  def list
    @list ||= []
  end

  def available_accounts_block
    sleep 2
    html_page = Nokogiri::HTML(browser.html)
    case account_nature
    when :standard
      html_page.css('div.acc-summary > div.ng-scope:first > div.box-border')
    when :deposit
      html_page.css('div.deposit-summary > div.ng-scope:first > div.box-border')
    end
  end

  def get_account_data
    available_accounts_block.each do |account_block|
      account_table_body = account_block.css('table tbody tr')

      account_table_body.each do |row|
        @account_available_balance = row.css('td')[0].text
      end

      case account_nature
      when :standard
        @currency = account_block.css('div.acc-summ-pos span').text.strip.tr("\n", '')
      when :deposit
        @currency = account_block.css('div.display-inl-block.ccy-d.margin-l-35 span').text.strip.tr("\n", '')
      end

      account_details = {
          name: account_block.css('div.display-inl-block.bg-circle-acc h5').text.strip.tr("\n", ''),
          currency: @currency,
          nature: account_nature,
          balance: @account_available_balance
      }

      save_data(account_details)
    end
  end

  private

  def visit_deposits_page
    navigate_to 'app.layout.DEPOSITS'
    @account_nature = :deposit
  end

  def visit_accounts_page
    navigate_to 'app.layout.ACCOUNTS'
    @account_nature = :standard
  end

  def save_data(account_details)
    new_account = Account.new(account_details)
    list << new_account
  end
end
