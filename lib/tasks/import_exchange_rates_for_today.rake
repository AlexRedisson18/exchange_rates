desc 'Import exchange rates for today'
task import_exchange_rates_for_today: :environment do
  ExchangeRatesImportService.new([Date.today]).call
end
