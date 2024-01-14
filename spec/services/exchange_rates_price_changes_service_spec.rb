require 'rails_helper'

RSpec.describe ExchangeRatesPriceChangesService, type: :service do
  subject(:service_call) { described_class.new.call }

  let(:monday_4_weeks_ago) { (Date.today - 28.days).beginning_of_week }
  let(:monday_3_weeks_ago) { (Date.today - 21.days).beginning_of_week }
  let(:monday_2_weeks_ago) { (Date.today - 14.days).beginning_of_week }
  let(:monday_1_week_ago) { (Date.today - 7.days).beginning_of_week }

  let!(:exchange_rate1) { ExchangeRate.create(date: monday_4_weeks_ago, currency: 'USD', price: 100.0) }
  let!(:exchange_rate2) { ExchangeRate.create(date: monday_4_weeks_ago + 6.days, currency: 'USD', price: 110.0) }

  let!(:exchange_rate3) { ExchangeRate.create(date: monday_3_weeks_ago, currency: 'USD', price: 150.0) }
  let!(:exchange_rate4) { ExchangeRate.create(date: monday_3_weeks_ago + 6.days, currency: 'USD', price: 160.0) }

  let!(:exchange_rate5) { ExchangeRate.create(date: monday_2_weeks_ago, currency: 'USD', price: 200.0) }
  let!(:exchange_rate6) { ExchangeRate.create(date: monday_2_weeks_ago + 6.days, currency: 'USD', price: 200.0) }

  let!(:exchange_rate7) { ExchangeRate.create(date: monday_1_week_ago, currency: 'USD', price: 100.0) }
  let!(:exchange_rate8) { ExchangeRate.create(date: monday_1_week_ago + 6.days, currency: 'USD', price: 70.0) }

  context 'when success' do
    let(:expected_result) do
      {
        'CNY' => ['-', '-', '-', '-'],
        'EUR' => ['-', '-', '-', '-'],
        'USD' => ['70.0₽(+30.0%)', '200.0₽(0.0%)', '160.0₽(-6.67%)', '110.0₽(-10.0%)']
      }
    end

    it 'import exchange rates for today and yesterday' do
      expect(service_call).to match(expected_result)
    end
  end
end
