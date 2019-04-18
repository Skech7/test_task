require 'webdrivers'
require 'watir'
require 'nokogiri'
require 'pry'
require 'json'

require_relative 'super_parser/accounts'
require_relative 'super_parser/transactions'

class SuperParser
  BASE_URL = 'https://my.fibank.bg/'.freeze

  attr_accessor :browser, :account_details, :last_transactions

  def initialize
    web_connect
    visit_profile_account_page
    get_accounts_details
    get_last_transactions
    browser.close

    puts account_details
    puts last_transactions
  end


  def web_connect
    @browser = Watir::Browser.new
    @browser.goto BASE_URL
  end

  def visit_profile_account_page
    browser.link(id: 'demo-link').click
  end

  def get_accounts_details
    list = Accounts.get_from(browser).list
    result_array = []
    list.each do |account|
      result_array << account.jsoned
    end
    @rest = {
      'accounts': result_array
    }
    @account_details = JSON.pretty_generate(@rest)
    save_to_json_file('accounts_details', @account_details)
  end

  def get_last_transactions
    @arr = [Transactions.get_last_five(browser).list_jsoned]
    transactions_hash = { 'transactions': @arr }

    @last_transactions = JSON.pretty_generate(transactions_hash)
    save_to_json_file('last_transactions',@last_transactions)
  end

  private

  def save_to_json_file(name, json_content)
    File.open("#{name}_details.json", 'w') do |f|
      f.puts json_content
    end
  end
end
