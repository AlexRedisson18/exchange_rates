class ExchangeRatesController < ApplicationController
  def index; end

  def price_changes
    @price_changes = ExchangeRatesPriceChangesService.new.call
  end
end
