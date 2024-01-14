class ExchangeRatesController < ApplicationController
  def index
    @prices = ExchangeRatesIndexService.new.call
  end

  def price_changes
    @price_changes = ExchangeRatesPriceChangesService.new.call
  end
end
