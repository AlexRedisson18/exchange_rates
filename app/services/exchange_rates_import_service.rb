class ExchangeRatesImportService
  def initialize(dates)
    @dates = dates
  end

  def call
    @dates.each do |date|
      response = HTTParty.get(url(date))
      response['ValCurs']['Valute'].each do |elem|
        next unless ExchangeRate::CURRENCIES.include?(elem['CharCode'])

        ExchangeRate.create(currency: elem['CharCode'], price: round_price(elem['Value']), date: date)
      end
    end
  end

  private

  def url(date)
    formatted_date = date.strftime('%d/%m/%Y')
    "https://www.cbr.ru/scripts/XML_daily.asp?date_req=#{formatted_date}"
  end

  # def days_offset
  #   current_week_offset = Date.today.wday
  #   minimal_days_count = 28
  #   minimal_days_count + current_week_offset
  # end

  # def days_range
  #   days_offset.days.ago.to_date..Date.today
  # end

  # def percents
  #   # monday price
  #   a = 100.0
  #   # sunday price
  #   b = 150.0
  #   ((b - a) * 100 / a).round(2)
  # end

  def round_price(price)
    price.gsub(',', '.').to_f.round(2)
  end
end
