class ExchangeRatesPriceChangesService
  def initialize; end

  def call
    grouped_rates = group_rates_by_dates(exchange_rates)
    calculate_price_changes(grouped_rates)
  end

  private

  def group_rates_by_dates(rates)
    result = {}
    rates.map do |date, currency, price|
      result[date.to_s] = {} unless result.key?(date.to_s)
      result[date.to_s][currency] = price
    end

    result
  end

  def exchange_rates
    @exchange_rates ||= ExchangeRate.where('date IN (?)', monday_and_sunday_dates).pluck(:date, :currency, :price)
  end

  # find all dates for mondays and sundays for last 4 weeks
  def monday_and_sunday_dates
    start_date = (Date.today - 28.days).beginning_of_week
    end_date = start_date + 27.days
    sunday_and_monday_wdays = [0, 1]

    @monday_and_sunday_dates ||= (start_date..end_date).select do |date|
      sunday_and_monday_wdays.include?(date.wday)
    end
  end

  def calculate_price_changes(rates)
    result = {}
    ExchangeRate::CURRENCIES.map do |currency|
      result[currency] = []
      monday_and_sunday_dates.map(&:to_s).each_slice(2) do |monday_date, sunday_date|
        monday_price = rates.dig(monday_date, currency)
        sunday_price = rates.dig(sunday_date, currency)
        result[currency].unshift(compare_price_changes(monday_price, sunday_price))
      end
    end
    result
  end

  def compare_price_changes(monday_price, sunday_price)
    return '-' if monday_price.nil? && sunday_price.nil?

    if monday_price.nil?
      "#{sunday_price}₽(0.0%)"
    elsif sunday_price.nil?
      "#{monday_price}₽(0.0%)"
    else
      "#{sunday_price}₽(#{percentage_difference(monday_price, sunday_price)})"
    end
  end

  def percentage_difference(monday_price, sunday_price)
    percent = ((sunday_price - monday_price) * 100 / monday_price).round(2)
    return '0.0%' if percent.zero?

    percent *= -1
    percent.negative? ? "#{percent}%" : "+#{percent}%"
  end
end
