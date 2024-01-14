require 'rails_helper'

RSpec.describe ExchangeRatesImportService, type: :service do
  subject(:service_call) { described_class.new(dates).call }

  context 'when success' do
    let(:dates) { Date.yesterday..Date.today }
    let(:new_records_count) { ExchangeRate::CURRENCIES.length * dates.count }

    it 'import exchange rates for today and yesterday' do
      expect { service_call }.to change(ExchangeRate, :count).by(new_records_count)
    end
  end

  context 'when empty dates' do
    let(:dates) { [] }

    it 'import exchange rates for today and yesterday' do
      expect { service_call }.not_to change(ExchangeRate, :count)
    end
  end
end
