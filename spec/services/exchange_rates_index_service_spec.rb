require 'rails_helper'

RSpec.describe ExchangeRatesIndexService, type: :service do
  subject(:service_call) { described_class.new.call }

  let!(:exchange_rate1) { ExchangeRate.create(date: (Date.yesterday - 1.month), currency: 'USD', price: 100.0) }
  let!(:exchange_rate2) { ExchangeRate.create(date: (Date.today - 1.month), currency: 'USD', price: 110.0) }
  let!(:exchange_rate3) { ExchangeRate.create(date: Date.today, currency: 'USD', price: 120.0) }

  let!(:exchange_rate4) { ExchangeRate.create(date: (Date.yesterday - 1.month), currency: 'EUR', price: 200.0) }
  let!(:exchange_rate5) { ExchangeRate.create(date: (Date.today - 1.month), currency: 'EUR', price: 210.0) }
  let!(:exchange_rate6) { ExchangeRate.create(date: Date.today, currency: 'EUR', price: 220.0) }

  let!(:exchange_rate7) { ExchangeRate.create(date: (Date.yesterday - 1.month), currency: 'CNY', price: 300.0) }
  let!(:exchange_rate8) { ExchangeRate.create(date: (Date.today - 1.month), currency: 'CNY', price: 310.0) }
  let!(:exchange_rate9) { ExchangeRate.create(date: Date.today, currency: 'CNY', price: 320.0) }

  context 'when success' do
    let(:expected_result) do
      "[[\"USD\",#{exchange_rate2.price},#{exchange_rate3.price}]," \
      "[\"EUR\",#{exchange_rate5.price},#{exchange_rate6.price}]," \
      "[\"CNY\",#{exchange_rate8.price},#{exchange_rate9.price}]]"
    end
    it 'import exchange rates for today and yesterday' do
      expect(service_call).to eq(expected_result)
    end
  end
end
