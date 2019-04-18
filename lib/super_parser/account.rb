require_relative 'transactions'
require_relative 'helper_methods'

class Account
  include HelperMethods

  attr_accessor :name, :currency, :balance, :nature

  def initialize(opts = {})
    @name = opts[:name]
    @currency = opts[:currency]
    @balance = opts[:balance]
    @nature = opts[:nature]
    @opts = opts
  end

  def jsoned
    hash_data(@opts)
  end
end
