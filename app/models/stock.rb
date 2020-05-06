class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: ENV['IEX_API_KEY'],
      secret_token: 'secret_token',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      # creating a new stock object with ticker, name, and last_price
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.update_price(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: ENV['IEX_API_KEY'],
      secret_token: 'secret_token',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    stock = where("ticker like ?", "#{ticker_symbol}" )
    stock.update(last_price: client.price(ticker_symbol))
  end
end
