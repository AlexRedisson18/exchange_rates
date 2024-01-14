require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :request do
  describe 'GET #index' do
    subject(:make_request) { get exchange_rates_url }

    let!(:exchange_rate) { ExchangeRate.create(date: (Date.today - 1.month), currency: 'USD', price: 110.0) }

    context 'when success' do
      it 'returns code 200' do
        make_request
        expect(response).to be_successful
      end

      it 'response has price' do
        make_request
        expect(response.body).to include exchange_rate.price.to_s
      end
    end
  end

  describe 'GET #price_changes' do
    subject(:make_request) { get price_changes_exchange_rates_url }

    let(:monday_4_weeks_ago) { (Date.today - 28.days).beginning_of_week }
    let!(:exchange_rate1) { ExchangeRate.create(date: monday_4_weeks_ago, currency: 'USD', price: 100.0) }
    let!(:exchange_rate2) { ExchangeRate.create(date: monday_4_weeks_ago + 6.days, currency: 'USD', price: 110.0) }
    let(:price_changes) { '110.0₽(-10.0%)' }

    context 'when success' do
      it 'returns code 200' do
        make_request
        expect(response).to be_successful
      end

      it 'response has price' do
        make_request
        expect(response.body).to include price_changes
      end
    end
  end
end
