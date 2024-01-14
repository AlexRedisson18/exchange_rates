class ExchangeRatesIndexService
  def initialize; end

  def call
    prices = convert_prices_to_hash
    conver_prices_to_array(prices)
  end

  private

  def convert_prices_to_hash
    return [] if exchange_rates.empty?

    result = {}
    ExchangeRate::CURRENCIES.each { |currency| result[currency] = [currency] }
    exchange_rates.each do |rate|
      rate_currency = rate[0]
      rate_price = rate[1].to_f
      result[rate_currency].push(rate_price)
    end
    result
  end

  def conver_prices_to_array(prices)
    return [] if prices.empty?

    result = []
    prices.each_value { |value| result.push(value) }
    result.to_json.html_safe
  end

  def exchange_rates
    last_month_dates = (Date.today - 1.month)..Date.today

    @exchange_rates ||= ExchangeRate.where('date IN (?)', last_month_dates).order(date: :asc).pluck(:currency, :price)
  end
end
